import random

__author__ = 'Valentin'

import sys

class Module(object):

    def __init__(self):
        self.n = 0

    def main(self, sys):
        method = getattr(self, sys.argv[1])
        method(*sys.argv[2:])

    def get_vector(self, value, n):
        return [int(i) for i in bin(value)[2:].zfill(n)]

    def vhdl(self, vectors):
        output = []
        template = \
        """
        --------------------
        ---GENERATED TEST---
        --------------------
        library IEEE;
        use IEEE.std_logic_1164.all;

        entity test is
            generic(test_n: natural := {n});
        end entity;

        architecture behavior of test is
            component course
                generic(n: natural := test_n);
                port(
                        input_vector: in std_logic_vector((2**n)-1 downto 0);
                        output_vector: out std_logic_vector(1 downto 0)
                    );
            end component;
            signal input_vector: std_logic_vector((2**test_n)-1 downto 0);
            signal output_vector: std_logic_vector(1 downto 0);
        begin

            input_vector <=

{input_vectors}


            scheme: course port map(input_vector=>input_vector, output_vector=>output_vector);
        end architecture;
        """
        time = 0
        last = len(vectors)
        for i in range(0, last):
            sys.stdout.write('{:.2%}\r'.format(((i+1)/len(vectors))))
            output.append("\t\t\t\"{}\" after {} ns{} -- answer: {}\n".format(''.join([str(i) for i in vectors[i]]), time, ';' if i == last-1 else ',',  int(self.is_symmetrical(vectors[i]))))
            time += 50
        template = template.format(n=self.n, input_vectors=''.join(output))
        f = open("test_generated.vhd", "w")
        f.write(template)
        f.close()

    def plain(self, vectors):
        output = []
        output_result = []
        for i in range(0,len(vectors)):
            sys.stdout.write('{:.2%}\r'.format(((i+1)/len(vectors))))
            output.append("{}\n".format(''.join([str(i) for i in vectors[i]])))
            output_result.append("{}\n".format(int(self.is_symmetrical(vectors[i]))))
        f = open("in.tst", "w")
        f.writelines(output)
        f.close()
        f = open("in_result.tst", "w")
        f.writelines(output_result)
        f.close()

    def random(self, *args):
        self.n = int(args[0])
        self.r = int(args[1])
        vectors = [self.get_vector(random.randrange(0, (2**self.n)**self.n), 2**self.n) for i in range(0, self.r)]
        getattr(self, args[2])(vectors)

    def all(self, *args):
        self.n = int(args[0])
        vectors = [self.get_vector(i, 2**self.n) for i in range(0, (2**self.n)**self.n)]
        getattr(self, args[1])(vectors)

    def sym(self, *args):
        self.n = int(args[0])
        vectors = []
        for i in range(0, (2**self.n)**self.n):
            vector = self.get_vector(i, 2**self.n)
            if self.is_symmetrical(vector):
                vectors.append(self.get_vector(i, 2**self.n))
        getattr(self, args[1])(vectors)

    def nsym(self, *args):
        self.n = int(args[0])
        vectors = []
        for i in range(0, (2**self.n)**self.n):
            vector = self.get_vector(i, 2**self.n)
            if not self.is_symmetrical(vector):
                vectors.append(self.get_vector(i, 2**self.n))
        getattr(self, args[1])(vectors)

    def is_symmetrical(self, input):
        for i in range(1, self.n):
            start_vector = self.get_vector(2**i-1, self.n)
            temp_vector = start_vector
            end_vector = start_vector[::-1]
            flag = input[int(''.join([str(i) for i in temp_vector]), 2)]
            while temp_vector != end_vector:
                temp_vector = self.generate_next_set(temp_vector)
                if flag != input[int(''.join([str(i) for i in temp_vector]), 2)]:
                    return False
        return True

    def generate_next_set(self, vector):
        for i in range(self.n-1, 0, -1):
            if vector[i] == 1 and vector[i-1] == 0:
                for j in range(self.n-1, i-1, -1):
                    if vector[j] == 1:
                        temp = vector[i-1]
                        vector[i-1] = vector[j]
                        vector[j] = temp
                        vector[i:] = vector[:i-1:-1]
                        return vector
        return vector

module = Module()
module.main(sys)