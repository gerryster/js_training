# Remove the answer sections to exercises.

fs = require('fs')
file_to_change = process.argv[2]
console.log "removing exercise answers from: #{file_to_change}"
throw "the first argument must be the path to a file" unless file_to_change
originalContent = fs.readFileSync(file_to_change, "utf8")
newContent = []

ex_begin_regex = /# exercise\{\{\{/
in_exercise = false

for line in originalContent.split("\n")
  omit_line = false
  if line.match ex_begin_regex
    newContent.push(line.replace ex_begin_regex, "implementMe()")
    in_exercise = true
  else if line.match(/# \}\}\}exercise/)
    in_exercise = false
    omit_line = true

  if not in_exercise and not omit_line
    newContent.push line

fs.writeFileSync(file_to_change, newContent.join("\n"), "utf8")
