local run = _m.textadept.run

-- compile commands
run.compile_command.java = 'javac "%(filename)"'

-- run commands
run.run_command.java = function()
  local buffer = buffer
  local text = buffer:get_text()
  local s, e, package
  repeat
    s, e, package = text:find('package%s+([^;]+)', e or 1)
  until not s or buffer:get_style_name(buffer.style_at[s]) ~= 'comment'
  if package then
    local classpath = ''
    for dot in package:gmatch('%.') do classpath = classpath..'../' end
    return 'java -cp '..(WIN32 and '%CLASSPATH%;' or '$CLASSPATH:')..
      classpath..'../ '..package..'.%(filename_noext)'
  else
    return 'java %(filename_noext)'
  end
end
run.run_command.pl = 'perl %(filename)'
run.run_command.php = 'php -f %(filename)'
run.run_command.py = 'python %(filename)'
run.run_command.rb = 'ruby %(filename)'

-- error details
-- java errors have the same format as ruby ones
run.error_detail.perl = {
  pattern = '^(.+) at (.-) line (%d+)',
  message = 1, filename = 2, line = 3
}
run.error_detail.php_error = {
  pattern = '^Parse error: (.+) in (.-) on line (%d+)',
  message = 1, filename = 2, line = 3
}
run.error_detail.php_warning = {
  pattern = '^Warning: (.+) in (.-) on line (%d+)',
  message = 1, filename = 2, line = 3
}
run.error_detail.python = {
  pattern = '^%s*File "([^"]+)", line (%d+)',
  filename = 1, line = 2
}
run.error_detail.ruby = {
  pattern = '^(.-):(%d+): (.+)$',
  filename = 1, line = 2, message = 3
}
