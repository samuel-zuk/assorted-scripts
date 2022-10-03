#!/bin/bash

# blahaj.sh
#
# Gets the stock level of BLAHAJ (or any item) at any IKEA store (defaults to Stoughton, MA)
#
# Requires: jq, curl
#
# Usage: ./blahaj.sh

item_code=90373590
store_code=158

response=$(curl -Gs -H "Accept: application/vnd.ikea.iows+json;version=1.0" -H "Contract: 37249" -H "Consumer: MAMMUT" https://iows.ikea.com/retail/iows/us/en/stores/$store_code/availability/ART/$item_code)

data=$(echo "$response" | jq -r ".StockAvailability.RetailItemAvailability")
stock=$(echo "$data" | jq -r ".AvailableStock.\"$\"")


if [[ $# -ne 0 ]] && ([[ "$1" = "-s" ]] || [[ "$1" = "--stock" ]]); then
    echo $stock
else
    if [[ $stock -eq 0 ]]; then
        restock_info=$(echo "$data" | jq -r ".StockAvailabilityInfoList.StockAvailabilityInfo[1].StockAvailInfoText.\"$\"")
        echo "No BLAHAJ in stock :("
        echo "$restock_info"
    else
        stocked_probability=$(echo "$data" | jq -r ".InStockProbabilityCode.\"$\"")
        echo "IKEA REPORTS $stock BLAHAJ IN STOCK!"
        echo "IN STORE BLAHAJ PROBABILITY: $stocked_probability"
    fi
fi
    
exit 0
