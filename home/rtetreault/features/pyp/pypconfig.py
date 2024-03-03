from pipetools import *
import pipetools
import re
 
 
remove_blank_lines = pipetools.where(pipetools.X.strip() != "")
rbl = remove_blank_lines
 
def pipe_re_split(pattern = r"\s+"):
    return pipetools.foreach(re.split, pattern)
 
prs = pipe_re_split
 
def index_print(iterable):
    return "[" + "".join(f"[{i}]{e}" for i,e in enumerate(iterable)) + "]"