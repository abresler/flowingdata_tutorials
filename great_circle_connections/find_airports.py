import csv

reader = csv.reader(open("ontime-flights.csv", "r"), delimiter=",")

skipped_header = False
airlines = []
for row in reader:
    if not skipped_header:
        skipped_header = True
        continue
    
    if row[8] not in airlines:
        airlines.append(row[8])
    
for a in airlines:
    print a