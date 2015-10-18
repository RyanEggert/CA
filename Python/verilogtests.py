from abc import ABCMeta, abstractmethod


def to_binary(integer, bits):
    defaultbin = bin(integer)[2:]
    if len(defaultbin) < bits:
        binrep = '0' * (bits - len(defaultbin)) + defaultbin
    elif len(defaultbin) == bits:
        binrep = defaultbin
    else:
        print 'ERROR'
        # Not enough bits specified.
        binrep = defaultbin
    return binrep


def twos_comp(val, bits):
    """compute the 2's compliment of int value val"""
    if (val & (1 << (bits - 1))) != 0:  # if sign bit is set e.g., 8bit: 128-255
        val = val - (1 << bits)        # compute negative value
    return val


class Module(object):
    __metaclass__ = ABCMeta
    """Base class for creating verilog modules"""

    def __init__(self, inputs, outputs):
        super(Module, self).__init__()
        self.inputs = inputs
        self.outputs = outputs
        self.all_test_cases = []

    @abstractmethod
    def output(self, input):
        output = input
        return output

    def format_vars(self, variables):
        output = ''
        for var in variables:
            output += var[0] + ' ' * \
                max(len(var[0]), (var[1] - len(var[0]))) + ' | '
        return output[:-1]

    def generate_module_begin(self):
        this_module = self.__class__.__name__
        print "module test_{module};".format(module=this_module)
        print "// 32-bit {module} has inputs a, b ; outputs out".format(module=this_module)
        print "// Definte I/O wires and regs below\n\n"
        print "// Instantiate 32-bit {module} here".format(module=this_module)
        print "<{module} module name> test_{module}(out, a, b);".format(module=this_module)
        print "initial begin"

    def generate_testbench_headers(self):
        formatted_inputs = self.format_vars(self.inputs)
        formatted_outputs = self.format_vars(self.outputs)
        print "$display(\"{prein}Inputs{postin}|{preoute}Expected Outputs{postoute}|{preout}Outputs{postout}|\");".format(
            prein=' ' * (len(formatted_inputs) / 2 - 3),
            postin=' ' * (len(formatted_inputs) / 2 - 3),
            preout=' ' * (len(formatted_outputs) / 2 - 3),
            postout=' ' * (len(formatted_outputs) / 2 - 4),
            preoute=' ' * (len(formatted_outputs) / 2 - 8),
            postoute=' ' * (len(formatted_outputs) / 2 - 8),
        )
        print "$display(\"{ins} {outs}\");".format(ins=formatted_inputs, outs=formatted_outputs)

    def generate_module_end(self):
        print "end"
        print "endmodule\n\n\n\n"

    def test_case(self, input):
        try:
            assert(len(input) == len(self.inputs))
        except AssertionError, e:
            print "Input Set = {}\nInput Headers = {}".format(input, self.inputs)
            raise(e)
        self.all_test_cases.append(input)

    def test_cases(self, inputs):
        for case in inputs:
            assert(len(case) == len(self.inputs))
        self.all_test_cases.extend(inputs)

    def calculate_test_cases(self):
        for input_set in self.all_test_cases:
            outputs = self.output(input_set)
            setstr = ''
            for i in range(len(self.inputs)):
                setstr += "{this_input}={bits}\'b{this_inputval}; ".format(
                    bits=self.inputs[i][1],
                    this_input=self.inputs[i][0],
                    this_inputval=str(input_set[i])
                    )
            print setstr
            print "$display(\"{ins} | {expouts} | {outs} |\", {invars}, {outvars});".format(
                ins= ' | '.join(['%b' for x in input_set]),
                expouts=' | '.join(['%b' for x in outputs]),
                outs=' | '.join(outputs),
                invars=', '.join([x[0] for x in self.inputs]),
                outvars=', '.join([x[2] for x in self.outputs])
                )
            print

def bitwise_not(bin_str):
    """Given a binary string, return the bitwise inversion"""
    inv_1=bin_str.replace('0', '2')
    inv_2=inv_1.replace('1', '0')
    inv_bin_str=inv_2.replace('2', '1')
    return inv_bin_str

class OR(Module):
    """32-bit 2-input OR gate."""

    def output(self, input):
        return [to_binary(int(input[0], 2) | int(input[1], 2), 32)]


class AND(Module):
    """32-bit 2-input AND gate."""

    def output(self, input):
        return [to_binary(int(input[0], 2) & int(input[1], 2), 32)]


class XOR(Module):
    """32-bit 2-input XOR gate."""

    def output(self, input):
        return [to_binary(int(input[0], 2) ^ int(input[1], 2), 32)]

class XNOR(Module):
    """32-bit 2-input XNOR gate."""

    def output(self, input):
        return [bitwise_not((to_binary(int(input[0], 2) ^ int(input[1], 2), 32)))]

class NOR(Module):
    """32-bit 2-input NOR gate."""

    def output(self, input):
        return [bitwise_not((to_binary(int(input[0], 2) | int(input[1], 2), 32)))]

class NAND(Module):
    """32-bit 2-input NAND gate."""

    def output(self, input):
        return [bitwise_not((to_binary(int(input[0], 2) & int(input[1], 2), 32)))]


def test_or():
    ormod=OR([('a', 32, 'a'), ('b', 32, 'a')], [('a OR b', 32, 'out')])
    ormod.generate_module_begin()
    ormod.generate_testbench_headers()
    ormod.test_case([to_binary(0, 32), to_binary(0, 32)])
    ormod.test_case([to_binary(0, 32), to_binary(1, 32)])
    ormod.test_case([to_binary(1, 32), to_binary(0, 32)])
    ormod.test_case([to_binary(1, 32), to_binary(1, 32)])
    ormod.test_case([to_binary(2**32 - 1, 32), to_binary(2**32 - 1, 32)])
    ormod.test_case([to_binary(0, 32), to_binary(2**32 - 1, 32)])
    ormod.test_case(['10' * 16, '01' * 16])
    ormod.test_case([to_binary(3, 32), to_binary(4, 32)])
    ormod.test_case([to_binary(888888888, 32), to_binary(1528764563, 32)])
    ormod.test_case(['00000000000000000000000000000011',
                     '00000000000011000000000000000011'])
    ormod.calculate_test_cases()
    ormod.generate_module_end()

def test_xor():
    xormod=XOR([('a', 32), ('b', 32)], [('a XOR b', 32, 'out')])
    xormod.generate_module_begin()
    xormod.generate_testbench_headers()
    xormod.test_case([to_binary(0, 32), to_binary(0, 32)])
    xormod.test_case([to_binary(0, 32), to_binary(1, 32)])
    xormod.test_case([to_binary(1, 32), to_binary(0, 32)])
    xormod.test_case([to_binary(1, 32), to_binary(1, 32)])
    xormod.test_case([to_binary(2**32 - 1, 32), to_binary(2**32 - 1, 32)])
    xormod.test_case([to_binary(0, 32), to_binary(2**32 - 1, 32)])
    xormod.test_case(['10' * 16, '01' * 16])
    xormod.test_case([to_binary(3, 32), to_binary(4, 32)])
    xormod.test_case([to_binary(888888888, 32), to_binary(1528764563, 32)])
    xormod.test_case(['00000000000000000000000000000011',
                     '00000000000011000000000000000011'])
    xormod.calculate_test_cases()
    xormod.generate_module_end()

def test_and():
    andmod=AND([('a', 32), ('b', 32)], [('a AND b', 32, 'out')])
    andmod.generate_module_begin()
    andmod.generate_testbench_headers()
    andmod.test_case([to_binary(0, 32), to_binary(0, 32)])
    andmod.test_case([to_binary(0, 32), to_binary(1, 32)])
    andmod.test_case([to_binary(1, 32), to_binary(0, 32)])
    andmod.test_case([to_binary(1, 32), to_binary(1, 32)])
    andmod.test_case([to_binary(2**32 - 1, 32), to_binary(2**32 - 1, 32)])
    andmod.test_case([to_binary(0, 32), to_binary(2**32 - 1, 32)])
    andmod.test_case(['10' * 16, '01' * 16])
    andmod.test_case([to_binary(3, 32), to_binary(4, 32)])
    andmod.test_case([to_binary(888888888, 32), to_binary(1528764563, 32)])
    andmod.test_case(['00000000000000000000000000000011',
                     '00000000000011000000000000000011'])
    andmod.calculate_test_cases()
    andmod.generate_module_end()

def test_xnor():
    xnormod=XNOR([('a', 32), ('b', 32)], [('a XNOR b', 32, 'out')])
    xnormod.generate_module_begin()
    xnormod.generate_testbench_headers()
    xnormod.test_case([to_binary(0, 32), to_binary(0, 32)])
    xnormod.test_case([to_binary(0, 32), to_binary(1, 32)])
    xnormod.test_case([to_binary(1, 32), to_binary(0, 32)])
    xnormod.test_case([to_binary(1, 32), to_binary(1, 32)])
    xnormod.test_case([to_binary(2**32 - 1, 32), to_binary(2**32 - 1, 32)])
    xnormod.test_case([to_binary(0, 32), to_binary(2**32 - 1, 32)])
    xnormod.test_case(['10' * 16, '01' * 16])
    xnormod.test_case([to_binary(3, 32), to_binary(4, 32)])
    xnormod.test_case([to_binary(888888888, 32), to_binary(1528764563, 32)])
    xnormod.test_case(['00000000000000000000000000000011',
                     '00000000000011000000000000000011'])
    xnormod.calculate_test_cases()
    xnormod.generate_module_end()

def test_nor():
    normod=NOR([('a', 32), ('b', 32)], [('a NOR b', 32, 'out')])
    normod.generate_module_begin()
    normod.generate_testbench_headers()
    normod.test_case([to_binary(0, 32), to_binary(0, 32)])
    normod.test_case([to_binary(0, 32), to_binary(1, 32)])
    normod.test_case([to_binary(1, 32), to_binary(0, 32)])
    normod.test_case([to_binary(1, 32), to_binary(1, 32)])
    normod.test_case([to_binary(2**32 - 1, 32), to_binary(2**32 - 1, 32)])
    normod.test_case([to_binary(0, 32), to_binary(2**32 - 1, 32)])
    normod.test_case(['10' * 16, '01' * 16])
    normod.test_case([to_binary(3, 32), to_binary(4, 32)])
    normod.test_case([to_binary(888888888, 32), to_binary(1528764563, 32)])
    normod.test_case(['00000000000000000000000000000011',
                     '00000000000011000000000000000011'])
    normod.calculate_test_cases()
    normod.generate_module_end()

def test_nand():
    nandmod=NAND([('a', 32), ('b', 32)], [('a NAND b', 32, 'out')])
    nandmod.generate_module_begin()
    nandmod.generate_testbench_headers()
    nandmod.test_case([to_binary(0, 32), to_binary(0, 32)])
    nandmod.test_case([to_binary(0, 32), to_binary(1, 32)])
    nandmod.test_case([to_binary(1, 32), to_binary(0, 32)])
    nandmod.test_case([to_binary(1, 32), to_binary(1, 32)])
    nandmod.test_case([to_binary(2**32 - 1, 32), to_binary(2**32 - 1, 32)])
    nandmod.test_case([to_binary(0, 32), to_binary(2**32 - 1, 32)])
    nandmod.test_case(['10' * 16, '01' * 16])
    nandmod.test_case([to_binary(3, 32), to_binary(4, 32)])
    nandmod.test_case([to_binary(888888888, 32), to_binary(1528764563, 32)])
    nandmod.test_case(['00000000000000000000000000000011',
                     '00000000000011000000000000000011'])
    nandmod.calculate_test_cases()
    nandmod.generate_module_end()


if __name__ == '__main__':
    test_or()
    test_nor()
    test_xor()
    test_xnor()
    test_and()
    test_nand()
