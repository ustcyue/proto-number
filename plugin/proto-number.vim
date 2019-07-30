function! ProtoReNumber()
python3 << EOF

import sys

import vim
import re


def run_command(command):
    vim.command(command)


def get_start_line_num(buf, start):
    cur_l, right_open = start, 1
    while cur_l >= 0 and right_open:
        line = buf[cur_l]
        if line.strip().endswith('}'):
            right_open += 1
        elif line.strip().endswith('{'):
            right_open -= 1
            if right_open == 0:
                break
        cur_l -= 1

    return cur_l


def process_till_end(buf, start):
    cur_l, cur_num = start, 1
    left_open = 1
    while cur_l < len(buf) and left_open:
        line = buf[cur_l]
        if line.strip().startswith('//'):
            cur_l += 1
            continue
        elif re.search('[\t ]+message|enum .*{', line):
            cur_open = 1
            cur_l += 1
            while cur_open:
                cur_line = buf[cur_l].strip()
                if cur_line.endswith('}'):
                    cur_open -= 1
                    if cur_open == 0:
                        break
                elif cur_line.endswith('{'):
                    cur_open += 1
                cur_l += 1

        elif re.search('[\t ]+oneof.*{', line):
            left_open += 1
        elif line.strip().endswith('}'):
            left_open -= 1
        else:
            m = re.match('.*=[ ]*([0-9]+)[; \[]+.*', line)
            if m:
                start, end = m.start(1), m.end(1)
                new_line = line[:start] + str(cur_num) + line[end:]
                buf[cur_l] = new_line
                cur_num += 1
        cur_l += 1


def process(buf, start_index):
    start = get_start_line_num(buf, start_index)
    process_till_end(buf, start+1)


c_line = vim.current.line
c_buf = vim.current.buffer
c_range = vim.current.range
range_beg = c_range.start
process(c_buf, range_beg)

EOF

endfunction

command! -nargs=0 ProtoReNumber call ProtoReNumber()
