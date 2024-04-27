from unittest import TestCase
from framework import AssemblyTest, print_coverage


class TestAbs(TestCase):
    def test_zero(self):
        t = AssemblyTest(self, "abs.s")
        # load 0 into register a0
        t.input_scalar("a0", 0)
        # call the abs function
        t.call("abs")
        # check that after calling abs, a0 is equal to 0 (abs(0) = 0)
        t.check_scalar("a0", 0)
        # generate the `assembly/TestAbs_test_zero.s` file and run it through venus
        t.execute()

    def test_one(self):
        # same as test_zero, but with input 1
        t = AssemblyTest(self, "abs.s")
        t.input_scalar("a0", 1)
        t.call("abs")
        t.check_scalar("a0", 1)
        t.execute()
    def test_minus_one(self):
        t = AssemblyTest(self, "abs.s")
        t.input_scalar("a0", -1)
        t.call("abs")
        t.check_scalar("a0", 1)
        t.execute()
    @classmethod
    def tearDownClass(cls):
        print_coverage("abs.s", verbose=False)


class TestRelu(TestCase):
    def test_simple(self):
        t = AssemblyTest(self, "relu.s")
        # create an array in the data section
        array0 = t.array([1, -2, 3, -4, 5, -6, 7, -8, 9])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # set a1 to the length of our array
        t.input_scalar("a1", len(array0))
        # call the relu function
        t.call("relu")
        # check that the array0 was changed appropriately
        t.check_array(array0, [1, 0, 3, 0, 5, 0, 7, 0, 9])
        # generate the `assembly/TestRelu_test_simple.s` file and run it through venus
        t.execute()
    def test_one(self):
        t = AssemblyTest(self, "relu.s")
        # create an array in the data section
        array0 = t.array([0])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # set a1 to the length of our array
        t.input_scalar("a1", len(array0))
        # call the relu function
        t.call("relu")
        # check that the array0 was changed appropriately
        t.check_array(array0, [0])
        # generate the `assembly/TestRelu_test_simple.s` file and run it through venus
        t.execute()
    def test_all_poistive(self):
        t = AssemblyTest(self, "relu.s")
        # create an array in the data section
        array0 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # set a1 to the length of our array
        t.input_scalar("a1", len(array0))
        # call the relu function
        t.call("relu")
        # check that the array0 was changed appropriately
        t.check_array(array0, [1, 2, 3, 4, 5, 6, 7, 8, 9])
        # generate the `assembly/TestRelu_test_simple.s` file and run it through venus
        t.execute()
    def test_all_negtive(self):
        t = AssemblyTest(self, "relu.s")
        # create an array in the data section
        array0 = t.array([-1, -2, -3, -4, -5, -6, -7, -8, -9])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # set a1 to the length of our array
        t.input_scalar("a1", len(array0))
        # call the relu function
        t.call("relu")
        # check that the array0 was changed appropriately
        t.check_array(array0, [0, 0, 0, 0, 0, 0, 0, 0, 0])
        # generate the `assembly/TestRelu_test_simple.s` file and run it through venus
        t.execute()
    def test_zero(self):
        t = AssemblyTest(self, "relu.s")
        array0 = t.array([0, -1, 0, 2, 3, -4])
        t.input_array("a0", array0)
        t.input_scalar("a1", len(array0))
        t.call("relu")
        t.check_array(array0, [0, 0, 0, 2, 3, 0])
        t.execute()
    def test_exception(self):
        t = AssemblyTest(self, "relu.s")
        array0 = t.array([])
        t.input_array("a0", array0)
        t.input_scalar("a1", len(array0))
        t.call("relu")
        t.execute(code=78)



    @classmethod
    def tearDownClass(cls):
        print_coverage("relu.s", verbose=False)


class TestArgmax(TestCase):
    def test_standard(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([3, -42, 432, 7, -5, 6, 5, -114, 2])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", len(array0))
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 2)
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute()

    def test_length_1(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([3])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", len(array0))
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 0)
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute()

    def test_invalid_n(self):
        t = AssemblyTest(self, "argmax.s")
        # set a1 to an invalid length of the array
        t.input_scalar("a1", 0)
        # call the `argmax` function
        t.call("argmax")
        # generate the `assembly/TestArgmax_test_invalid_n.s` file and run it through venus
        t.execute(code=77)

    @classmethod
    def tearDownClass(cls):
        print_coverage("argmax.s", verbose=False)


class TestDot(TestCase):
    def test_simple(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        array0 = t.array([1,2,3,4,5,6,7,8,9])
        array1 = t.array([1,2,3,4,5,6,7,8,9])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        t.input_scalar("a2", len(array0))
        t.input_scalar("a3", 1)
        t.input_scalar("a4", 1)
        # load array attributes into argument registers
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.check_scalar("a0", 285)
        t.execute()
    def test_different(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        array0 = t.array([1,2,3,4,5,6,7,8,9])
        array1 = t.array([1,2,3,4,5,6,7,8,9])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        t.input_scalar("a2", 3)
        t.input_scalar("a3", 1)
        t.input_scalar("a4", 2)
        # load array attributes into argument registers
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.check_scalar("a0", 22)
        t.execute()
    def test_length_error(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        array0 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        array1 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", 0)
        t.input_scalar("a3", 1)
        t.input_scalar("a4", 1)
        # call the `dot` function
        t.call("dot")
        t.execute(code=75)

    def test_stride_error(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        array0 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        array1 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", len(array0))
        t.input_scalar("a3", 0)
        t.input_scalar("a4", 1)
        # call the `dot` function
        t.call("dot")
        t.execute(code=76)

    @classmethod
    def tearDownClass(cls):
        print_coverage("dot.s", verbose=False)


class TestMatmul(TestCase):

    def do_matmul(self, m0, m0_rows, m0_cols, m1, m1_rows, m1_cols, result, code=0):
        t = AssemblyTest(self, "matmul.s")
        # we need to include (aka import) the dot.s file since it is used by matmul.s
        t.include("dot.s")

        # create arrays for the arguments and to store the result
        array0 = t.array(m0)
        array1 = t.array(m1)
        array_out = t.array([0] * len(result))

        # load address of input matrices and set their dimensions
        t.input_array("a0", array0)
        t.input_scalar("a1", m0_rows)
        t.input_scalar("a2", m0_cols)

        t.input_array("a3", array1)
        t.input_scalar("a4", m1_rows)
        t.input_scalar("a5", m1_cols)
        # load address of output array
        t.input_array("a6", array_out)
        # call the matmul function
        t.call("matmul")

        # check the content of the output array
        t.check_array(array_out, result)

        # generate the assembly file and run it through venus, we expect the simulation to exit with code `code`
        t.execute(code=code)

    def test_simple(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150]
        )

    def test_simple_single(self):
        self.do_matmul(
            [1], 1, 1,
            [1], 1, 1,
            [1]
        )
    def test_two(self):
        self.do_matmul(
            [1, 0, 2, -1, 3, 1], 2, 3,
            [3, 1, 2, 1, 1, 0], 3, 2,
            [5, 1, 4, 2]
        )
    def test_m0_dimension(self):
        self.do_matmul([1], 0, 1, [1], 1, 1, [1], 72)
        self.do_matmul([1], 1, -1, [1], 1, 1, [1], 72)

    def test_m1_dimension(self):
        self.do_matmul([1], 1, 1, [1], 0, 1, [1], 73)
        self.do_matmul([1], 1, 1, [1], 1, -1, [1], 73)

    def test_dimension_mismatch(self):
        self.do_matmul([1], 1, 1, [1, 2], 2, 1, [2], 74)
    
    @classmethod
    def tearDownClass(cls):
        print_coverage("matmul.s", verbose=False)


class TestReadMatrix(TestCase):

    def doReadMatrix(self, input_file = "inputs/test_read_matrix/test_input.bin",
     result_row = 3, result_col = 3, result_array = [1, 2, 3, 4, 5, 6, 7, 8, 9], fail='', code=0):
        t = AssemblyTest(self, "read_matrix.s")
        # load address to the name of the input file into register a0
        t.input_read_filename("a0", input_file)

        # allocate space to hold the rows and cols output parameters
        rows = t.array([-1])
        cols = t.array([-1])

        # load the addresses to the output parameters into the argument registers
        t.input_array("a1", rows)
        t.input_array("a2", cols)

        # call the main function within test_read_matrix_no_cc, which randomizes registers and calls read_matrix
        t.call("read_matrix")

        # check the output from the function
        t.check_array(rows, [result_row])
        t.check_array(cols, [result_col])
        t.check_array_pointer("a0", result_array)

        # generate assembly and run it through venus
        t.execute(fail=fail, code=code)

    def test_simple_read(self):
        self.doReadMatrix()

    def test_simple0(self):
        self.doReadMatrix(input_file = "inputs/simple0/bin/inputs/input2.bin", result_row = 3,
         result_col = 1, result_array= [2, 1, 6])
    def test_larger0(self):
        self.doReadMatrix(input_file = "inputs/larger0/bin/inputs/input0.bin", result_row = 15,
         result_col = 15,
         result_array= [-5, 2, 1, 8, 12, 12, -1, 13, 2, 15, 15, 0, -5, 5, 10,
                        -5, 15, 1, 15, -3, 1, 3, 9, 8, 14, 0, 15, -2, 8, 12,
                        15, 10, 5, 5, 11, 14, 2, -4, 0, -1, 10, 5, 10, 15, 1,
                        5, 6, -5, 6, 12, 13, 6, 13, 8, 8, -3, 8, -4, -1, 12,
                        0, 13, 15, 7, -2, 5, -5, 3, -3, 12, 1, -5, -2, 10, -4,
                        9, -3, 9, 3, -4, 10, 3, 9, 2, -1, 6, 11, 15, 7, 7,
                        -3, 7, 11, 6, 2, 11, -4, 0, -1, 3, 14, 15, 10, 13, -1,
                        9, -5, 7, 10, -1, -5, 12, 8, 7, 12, 3, -5, 4, 2, -3,
                        10, 12, 15, -2, 2, 1, -5, 7, 0, 2, 11, 2, 8, 14, 15,
                        13, -2, 7, 13, 7, 8, 13, 0, 5, 8, 6, 7, 0, -3, 2,
                        15, 12, -1, 12, 10, 15, -3, 12, -1, -4, 0, 6, 3, 7, 2,
                        -4, 7, -2, 9, 12, 5, -1, 12, -4, 10, -3, -4, -4, 10, 2,
                        15, 3, 10, 0, 7, -1, -4, 7, 9, 8, -3, -5, 6, 9, 11,
                        5, 13, 14, 7, 0, 9, 9, -1, 0, 5, 5, 15, -5, -5, 12,
                        0, 2, -5, 0, 9, -1, 14, 3, 3, -1, 0, 7, 5, 14, 13])

    def test_fail_fopen(self):
        self.doReadMatrix(fail='fopen', code=90)

    def test_fail_fread(self):
        self.doReadMatrix(fail='fread', code=91)

    def test_fail_fclose(self):
        self.doReadMatrix(fail='fclose', code=92)

    def test_fail_malloc(self):
        self.doReadMatrix(fail='malloc', code=88)

    @classmethod
    def tearDownClass(cls):
        print_coverage("read_matrix.s", verbose=False)


class TestWriteMatrix(TestCase):

    def do_write_matrix(self, fail='', code=0):
        t = AssemblyTest(self, "write_matrix.s")
        outfile = "outputs/test_write_matrix/student.bin"
        # load output file name into a0 register
        t.input_write_filename("a0", outfile)
        # load input array and other arguments
        rows = 3
        cols = 3
        test_input = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        t.input_scalar("a2", 3)
        t.input_scalar("a3", 3)
        t.input_array("a1", t.array([1, 2, 3, 4, 5, 6, 7, 8, 9]))
        # call `write_matrix` function
        t.call("write_matrix")
        # generate assembly and run it through venus
        t.execute(fail=fail, code=code)
        # compare the output file against the reference
        if code == 0:
            t.check_file_output(outfile, "outputs/test_write_matrix/reference.bin")

    def test_simple(self):
        self.do_write_matrix()
    def test_fail_fopen(self):
        self.do_write_matrix(fail='fopen', code=93)

    def test_fail_fwrite(self):
        self.do_write_matrix(fail='fwrite', code=94)

    def test_fail_fclose(self):
        self.do_write_matrix(fail='fclose', code=95)
    @classmethod
    def tearDownClass(cls):
        print_coverage("write_matrix.s", verbose=False)


class TestClassify(TestCase):

    def make_test(self):
        t = AssemblyTest(self, "classify.s")
        t.include("argmax.s")
        t.include("dot.s")
        t.include("matmul.s")
        t.include("read_matrix.s")
        t.include("relu.s")
        t.include("write_matrix.s")
        return t

    def test_simple0_input0(self):
        t = self.make_test()
        out_file = "outputs/test_basic_main/student0.bin"
        ref_file = "outputs/test_basic_main/reference0.bin"
        args = ["inputs/simple0/bin/m0.bin", "inputs/simple0/bin/m1.bin",
                "inputs/simple0/bin/inputs/input0.bin", out_file]
        # call classify function
        t.input_scalar("a2", 0)
        t.call("classify")
        # generate assembly and pass program arguments directly to venus
        t.execute(args=args)
        # compare the output file and
        t.check_file_output(out_file, ref_file)
        t.check_stdout("2")
        # compare the classification output with `check_stdout`

    @classmethod
    def tearDownClass(cls):
        print_coverage("classify.s", verbose=False)


class TestMain(TestCase):

    def run_main(self, inputs, output_id, label):
        args = [f"{inputs}/m0.bin", f"{inputs}/m1.bin", f"{inputs}/inputs/input0.bin",
                f"outputs/test_basic_main/student{output_id}.bin"]
        reference = f"outputs/test_basic_main/reference{output_id}.bin"
        t = AssemblyTest(self, "main.s", no_utils=True)
        t.call("main")
        t.execute(args=args, verbose=False)
        t.check_stdout(label)
        t.check_file_output(args[-1], reference)

    def test0(self):
        self.run_main("inputs/simple0/bin", "0", "2")

    def test1(self):
        self.run_main("inputs/simple1/bin", "1", "1")
