# importing the module
import json
 
# Opening JSON file
with open('dbt_nhl_analytics/target/manifest.json') as json_file:
    data = json.load(json_file)

for model in data['nodes']:
    if model.split('.')[0] == 'model':
        print(model)