import csv, time, MySQLdb

connection = MySQLdb.Connect(host='localhost', user='root', passwd='', db='ufo')
cursor = connection.cursor()

sql_beg = 'SELECT COUNT(*) FROM sightings WHERE MBRContains(GeomFromText(\'LineString('
sql_end = ')\'), lat_lng)'

lat_NW = 54.162434
lng_NW = -135.351563
lat_SE = 23.725012
lng_SE = -61.347656

# About 5 miles
# lat_incr = -.0725
# lng_incr = .0725

# About 20 miles
lat_incr = -.29
lng_incr = .29

lat_curr = lat_NW
lng_curr = lng_NW
cnt_matrix = []
num_rows = 0

while lat_curr > lat_SE:
    
    lat_nxt = lat_curr + lat_incr
    lng_curr = lng_NW
    row_curr = []
    
    while lng_curr < lng_SE:
        lng_nxt = lng_curr + lng_incr
        
        sql = sql_beg + str(lat_curr) + " " + str(lng_curr) + ", " + str(lat_nxt) + " " + str(lng_nxt) + sql_end 
        cursor.execute(sql)
        result = cursor.fetchone()
        cnt = result[0]
        row_curr.append(cnt)
        
        lng_curr += lng_incr
        
        #### DEBUG
        # print str(lat_curr) + ", " + str(lng_curr) + ", " + str(cnt)
        
    cnt_matrix.append(row_curr)
    lat_curr += lat_incr
    num_rows += 1

    # if num_rows == 2:
    #     break

for i in range(len(cnt_matrix)):
    s = ', '.join(map(str, cnt_matrix[i]))
    print s
        
