require 'json'
require 'google_drive'


username = ""
password = ""
spreadSheetKey = ""


#setup our data
data = File.open("data.txt").read
parsed = JSON.parse(data)
session = GoogleDrive.login(username, password)

# First worksheet of
# https://docs.google.com/spreadsheet/ccc?key=${spreadSheetKey}
ws = session.spreadsheet_by_key(spreadSheetKey).worksheets[0]

# Dumps all cells.
for row in 1..ws.num_rows
  for col in 1..ws.num_cols
    p ws[row, col]
  end
end

#save our changes which cleans up our doc. probably not required.
ws.save()

#this is where we turn our entries into our table
parsed["entries"].each_with_index { |entry,i|
  ws[i+1,1] = entry["id"]
  ws[i+1,2] = entry["title"]
  ws[i+1,3] = entry["fullTitle"]
  ws[i+1,4] = entry["pl1$VTAG"]
}

#save our data now into the table
ws.save()
