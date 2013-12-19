import urllib2, simplejson, time
from distancesphere import distance_on_unit_sphere

# GOOGLE_API_KEY = 'INSERT_YOUR_GOOGLE_API_KEY_HERE'

# Country corners
lat_NW = 49.44098806129775
lng_NW = -127.13476612499217
lat_SE = 23.725012
lng_SE = -61.347656

# Chicago corners
# lat_NW = 42.31633902304016
# lng_NW = -88.41900012453226
# lat_SE = 41.40815250573106  
# lng_SE = -87.20501086671956

# About 20 miles
lat_incr = -.29
lng_incr = .29

# About 2 miles
# lat_incr = -.029
# lng_incr = .029

# Start in the northwest and iterate to the southeast
lat_curr = lat_NW
lng_curr = lng_NW
total_calls = 0
print 'lat,lng,latnear,lngnear,dist_miles'
while lat_curr > lat_SE:
    
    lng_curr = lng_NW
    
    while lng_curr < lng_SE:
        
        # DEBUG
        # time.sleep(1)
        # if total_calls > 20:
        #     break
        
        curr_location = str(lat_curr) + "," + str(lng_curr)
        
        # Search for nearest grocery
        # url = 'https://maps.googleapis.com/maps/api/place/search/json?location=' + curr_location + '&sensor=false&key='+GOOGLE_API_KEY+'&rankby=distance&types=grocery_or_supermarket'
        
        # 10-mile search radius
        url = 'https://maps.googleapis.com/maps/api/place/search/json?location=' + curr_location + '&sensor=false&key=' + GOOGLE_API_KEY + '&radius=16100&types=grocery_or_supermarket'
        
        # Ping the API
        response = urllib2.urlopen(url)
        result = response.read()
        d = simplejson.loads(result)
        total_calls += 1
        
        # Check status
        if d['status'] not in ['OK', 'ZERO_RESULTS']:
            print 'ERROR. Status: ' + d['status']
            break
        
        # If no result, radius 25,000 meters
        if len(d['results']) == 0:
            url = 'https://maps.googleapis.com/maps/api/place/search/json?location=' + curr_location + '&sensor=false&key='+GOOGLE_API_KEY+'&radius=25000&types=grocery_or_supermarket'
            response = urllib2.urlopen(url)
            result = response.read()
            d = simplejson.loads(result)
            total_calls += 1
        
        # If still no result, radius 50,000 meters
        if len(d['results']) == 0:
            url = 'https://maps.googleapis.com/maps/api/place/search/json?location=' + curr_location + '&sensor=false&key='+GOOGLE_API_KEY+'&radius=50000&types=grocery_or_supermarket'
            response = urllib2.urlopen(url)
            result = response.read()
            d = simplejson.loads(result)
            total_calls += 1
        
        # Output nearest grocery store
        if len(d['results']) > 0:
            
            least_miles = 999999999
            for g in d['results']:
                near_lat = g['geometry']['location']['lat']
                near_lng = g['geometry']['location']['lng']
                dist_miles = distance_on_unit_sphere(lat_curr, lng_curr, near_lat, near_lng)
                if dist_miles < least_miles:
                    least_miles = dist_miles
                    nearest_lat = near_lat
                    nearest_lng = near_lng
            print curr_location + ',' + str(nearest_lat) + ',' + str(nearest_lng) + ',' + str(least_miles)
        
        # Or no location found
        else:
            print curr_location + ',,,'
        
        lng_curr += lng_incr
    lat_curr += lat_incr

# DEBUG 
# print 'Total calls: ' + str(total_calls)