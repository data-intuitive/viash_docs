import unittest
import os
from os import path
import subprocess

class Tester(unittest.TestCase):
    def simple_test(self):
        out = subprocess.check_output(["./hello_world_py", "I", "am", "viash"]).decode("utf-8")
        self.assertEqual(out, "Hello world! I am viash\n")
        
    def less_params(self):
        out = subprocess.check_output(["./hello_world_py"]).decode("utf-8")
        self.assertEqual(out, "Hello world!\n")
        
    def simple_test(self):
        out = subprocess.check_output(["./hello_world_py", "General", "Kenobi", "--greeter=Hello there."]).decode("utf-8")
        self.assertEqual(out, "Hello there. General Kenobi.\n")

unittest.main()
