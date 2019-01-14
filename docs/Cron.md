# Cron

some docs from various places are below, cobbled from various manpages, etc.

```
# This file includes the <user> column, and should be symlinked into
# /etc/cron.d/, not edited via "crontab -e".
#
# Each task to run has to be defined through a single line
# indicating with different fields when the task will be run
# and what command to run for the task
#
# To define the time you can provide concrete values for
# minute (m), hour (h), day of month (dom), month (mon),
# and day of week (dow) or use '*' in these fields (for 'any').#
# Notice that tasks will be started based on the cron's system
# daemon's notion of time and timezones.
#
# Output of the crontab jobs (including errors) is sent through
# email to the user the crontab file belongs to (unless redirected).
#
# FORMATTING
#
# The time and date fields are:
#
# field	allowed values
# minute	0-59
# hour	0-23
# day of month	1-31
# month	1-12 (or names, see below)
# day of week	0-7 (0 or 7 is Sunday, or use names)
# A field may contain an asterisk (*), which always stands for "first-last".
#
# Ranges of numbers are allowed. Ranges are two numbers separated with a
# hyphen. The specified range is inclusive. For example, 8-11 for an 'hours'
# entry specifies execution at hours 8, 9, 10, and 11.
#
# Lists are allowed. A list is a set of numbers (or ranges) separated by
# commas. Examples: "1,2,5,9", "0-4,8-12".
#
# Step values can be used in conjunction with ranges. Following a range with
# "/<number>" specifies skips of the number's value through the range. For
# example, "0-23/2" can be used in the 'hours' field to specify command
# execution for every other hour (the alternative in the V7 standard is
# "0,:2,:4,:6,:8,:10,:12,:14,:16,:18,:20,:22"). Step values are also permitted
# after an asterisk, so if specifying a job to be run every two hours, you can
# use "*/2".
#
# Names can also be used for the 'month' and 'day of week' fields. Use the
# first three letters of the particular day or month (case does not matter).
# Ranges or lists of names are not allowed.
#
# The "sixth" field (the rest of the line) specifies the command to be run. The
# entire command portion of the line, up to a newline or a "%" character, will
# be executed by /bin/sh or by the shell specified in the SHELL variable of the
# cronfile. A "%" character in the command, unless escaped with a backslash
# (\), will be changed into newline characters, and all data after the first %
# will be sent to the command as standard input.
#
# NOTE: The day of a command's execution can be specified in the following two
# fields --- 'day of month', and 'day of week'. If both fields are restricted
# (i.e., do not contain the "*" character), the command will be run when either
# field matches the current time. For example, "30 4 1,15 * 5" would cause a
# command to be run at 4:30 am on the 1st and 15th of each month, plus every
# Friday.
#
# EXAMPLES
#
# Compress /home to /var/backups/home.tgz at 5 a.m every week with:
# 0 5 * * 1 root tar -zcf /var/backups/home.tgz /home/
#
# Run /usr/bin/daily.job five minutes after midnight, every day as user foo:
# 5 0 * * * foo /usr/bin/daily.job
#
# Run /usr/bin/monthly.job at 2:15pm on the first of every month as user bar:
# 15 14 1 * * bar /usr/bin/monthly
#
# Send a message to John Doe at 10 pm on weekdays:
# 0 22 * * 1-5 root mail -s "It's 10pm" jdoe%John,%%Where are your kids?%
#
# Some miscellaneous examples:
# 23 0-23/2 * * * root echo "run 23 minutes after midn, 2am, 4am ..., everyday"
# 5 4 * * sun     root echo "run at 5 after 4 every sunday"
#
# NOTE: The last line MUST be blank!
```
