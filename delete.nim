#nimble install nap
import os, times, strformat, logging, nap

add_arg(name="days", kind="argument", required=true, help="Number of days")
add_arg(name="extension", kind="argument", required=true, help="File extension")
add_arg(name="path", kind="argument", required=true, help="Folder path for the files")
add_arg(name="logs", kind="argument", required=true, help="Folder pth for the log files")

parse_args()

var number_of_days = int get_arg("days").getInt()
var file_extension =  get_arg("extension").value
var files_full_path =  get_arg("path").value
var logs_full_path =  get_arg("logs").value

proc GetTodayDate(): string =
    let today_date = now().getDateStr
    let dt_new = parse(today_date, "yyyy-MM-dd")
    return dt_new.format("dd-MM-yyyy")

proc GenerateDeleteDate(number_of_days_to_deduct:int): string =
    let today = (now() - number_of_days_to_deduct.days).getDateStr
    let dt = parse(today, "yyyy-MM-dd")
    return dt.format("dd-MM-yyyy")

var DeleteDate = GenerateDeleteDate(number_of_days)
var rollingLog = newRollingFileLogger(fmt"{logs_full_path}/{GetTodayDate()}.log")

for f in walkFiles(fmt"{files_full_path}/*.{file_extension}"):
    addHandler(rollingLog)
    var w_date_time = f.getCreationTime 
    var w_date = w_date_time.format("dd-MM-yyyy")
    echo w_date
    if w_date <= DeleteDate:
        removeFile(f)
        info(fmt"File: {f} , deleted on {GetTodayDate()} .")