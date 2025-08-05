#!/bin/bash
CONF_FILE="sig.conf"

# Function to validate input
validate_input() {
    local prompt="$1"
    local valid_options="$2"
    local case_format="$3" # "upper", "lower", "capitalize"
    local input
    while true; do
        read -p "$prompt" input
        # Change case for validation
        local input_upper=$(echo "$input" | tr '[:lower:]' '[:upper:]')
        local valid_upper=$(echo "$valid_options" | tr '[:lower:]' '[:upper:]')

        if [[ " $valid_upper " =~ " $input_upper " ]]; then
            # Convert to required case format
            case "$case_format" in
                upper) input=$(echo "$input_upper") ;;
                lower) input=$(echo "$input" | tr '[:upper:]' '[:lower:]') ;;
                capitalize) input="$(tr '[:lower:]' '[:upper:]' <<< ${input:0:1})${input:1}" ;;
            esac
            echo "$input"
            break
        else
            echo "Invalid input, try again."
        fi
    done
}

# Get inputs
component=$(validate_input "Enter Component Name [INGESTOR/JOINER/WRANGLER/VALIDATOR]: " "INGESTOR JOINER WRANGLER VALIDATOR" "upper")
scale=$(validate_input "Enter Scale [MID/HIGH/LOW]: " "MID HIGH LOW" "upper")
view=$(validate_input "Enter View [Auction/Bid]: " "Auction Bid" "capitalize")

# Count validation
while true; do
    read -p "Enter Count [single digit number]: " count
    if [[ "$count" =~ ^[0-9]$ ]]; then
        break
    else
        echo "Invalid count. Enter a single digit number."
    fi
done

# Determine vdopia-etl value
if [[ "$view" == "Auction" ]]; then
    vdopia_val="vdopiasample"
else
    vdopia_val="vdopiasample-bid"
fi

# New line format
new_line="$view ; $scale ; $component ; ETL ; $vdopia_val = $count"

# If the file is not present, it will create a new file.
if [[ ! -f "$CONF_FILE" ]]; then
    echo "$new_line" > "$CONF_FILE"
    echo "Created $CONF_FILE with new entry."
    exit 0
fi


match_line=$(grep -n "^$view ; $scale ; $component ; ETL ;" "$CONF_FILE")

if [[ -n "$match_line" ]]; then

    line_num=$(echo "$match_line" | head -n 1 | cut -d: -f1)
    sed -i "${line_num}s|=.*|= $count|" "$CONF_FILE"
    echo "Updated count for matching line."
else
    echo "$new_line" >> "$CONF_FILE"
    echo "Appended new line."
fi

