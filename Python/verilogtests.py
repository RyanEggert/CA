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
        print variables
        for var in variables:
            output += var[0] + ' ' * \
                max(len(var[0]), (var[1] - len(var[0]))) + ' | '
        return output[:-1]

    def generate_testbench_headers(self):
        formatted_inputs = self.format_vars(self.inputs)
        print formatted_inputs
        formatted_outputs = self.format_vars(self.outputs)
        print formatted_outputs
        print "$display(\"{prein}Inputs{postin}|{preout}Outputs{postout}|\");".format(
            prein=' ' * (len(formatted_inputs) / 2 - 3),
            postin=' ' * (len(formatted_inputs) / 2 - 3),
            preout=' ' * (len(formatted_outputs) / 2 - 3),
            postout=' ' * (len(formatted_outputs) / 2 - 4),
        )
        print "$display(\"{ins} {outs}\");".format(ins=formatted_inputs, outs=formatted_outputs)

    def test_case(self, input):
        assert(len(input) == len(self.inputs))
        self.all_test_cases.append(input)

    def test_cases(self, inputs):
        for case in inputs:
            assert(len(case) == len(self.inputs))
        self.all_test_cases.extend(inputs)

    def calculate_test_cases(self):
        for input_set in self.all_test_cases:
            outputs = self.output(input_set)
            print "$display(\"{ins} | {outs} |\");".format(ins=' | '.join(input_set), outs=' | '.join(outputs))


def main():
    class Testing(Module):
        """docstring for Testing"""

        def output(self, input):
            return [to_binary(int(input[0], 2) | int(input[1], 2), 32)]
    testing = Testing([('a', 32), ('b', 32)], [('a OR b', 32)])
    testing.generate_testbench_headers()
    testing.test_case([to_binary(3, 32), to_binary(4, 32)])
    testing.calculate_test_cases()

if __name__ == '__main__':
    main()
