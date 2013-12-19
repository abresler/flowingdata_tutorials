import MySQLdb, csv
db = MySQLdb.connect(user="root", db="places")
c = db.cursor()

for i in range(2,7):
    filename = 'nearest-grocery' + str(i) + '.csv'
    reader = csv.reader(open(filename, 'rb'), delimiter=',')
    skipped_header = False
    for row in reader:
        if not skipped_header:
            skipped_header = True
            continue
        
        # If no result from Google
        if row[2] == '' or row[3] == '':
            continue
        
        # Only add unique locations
        query = "SELECT * FROM `grocery` WHERE `latitude` = '" + str(row[2]) + "' AND `longitude` = '" + str(row[3]) + "'"
        c.execute(query)
        if len(c.fetchall()) > 0:
            continue
        
        sql = "INSERT INTO `grocery` (latitude, longitude) VALUES ("
        sql += "'" + str(row[2]) + "','" + str(row[3]) + "'"
        sql += ")"
        c.execute(sql)