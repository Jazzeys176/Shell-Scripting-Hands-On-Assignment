# Shell Script Hands-On Assignment - Jayant Nag Sai Vasa

## Overview
This assignment is about creating a **Bash shell script** that updates or appends entries in a configuration file (`sig.conf`) based on user input. The script ensures **input validation**, **case handling**, and **conditional updating** of the file.

The configuration file contains lines in the following format:

```
<view> ; <scale> ; <component name> ; ETL ; <vdopia-etl> = <count>
```

Where:
- **view** → `Auction` or `Bid`
- **scale** → `MID`, `HIGH`, or `LOW`
- **component name** → `INGESTOR`, `JOINER`, `WRANGLER`, `VALIDATOR`
- **count** → Single-digit number
- **vdopia-etl** → `vdopiasample` for Auction, `vdopiasample-bid` for Bid

---

## Script Workflow
1. **Prompt for Inputs**  
   The script asks for four inputs:
   - **Component Name** `[INGESTOR/JOINER/WRANGLER/VALIDATOR]`
   - **Scale** `[MID/HIGH/LOW]`
   - **View** `[Auction/Bid]`
   - **Count** `[single digit number]`

   It validates each input against allowed options and converts them into the required case format automatically.

2. **Generate the New Entry**  
   The script forms a line in the format:
   ```
   <view> ; <scale> ; <component name> ; ETL ; <vdopia-etl> = <count>
   ```

3. **File Handling Logic**
   - **If `sig.conf` does not exist** → Create it and add the new entry.
   - **If an entry with the same first 3 fields exists** (`view ; scale ; component`) → Update only the count for that line.
   - **If no exact match is found** → Append the new entry as a new line.

4. **Case Handling**
   - User can type values in any case (upper/lower/mixed).
   - The script standardizes them before processing.

---

## Example Usage

### Initial `sig.conf`
```
Auction ; MID ; INGESTOR ; ETL ; vdopiasample = 7
Bid ; HIGH ; JOINER ; ETL ; vdopiasample-bid = 3
Auction ; LOW ; WRANGLER ; ETL ; vdopiasample = 4
```

### Case 1: Update Existing Count
**Input:**  
```
Component Name: INGESTOR
Scale: MID
View: Auction
Count: 4
```
**Result:**
```
Auction ; MID ; INGESTOR ; ETL ; vdopiasample = 4
Bid ; HIGH ; JOINER ; ETL ; vdopiasample-bid = 3
Auction ; LOW ; WRANGLER ; ETL ; vdopiasample = 4
```

---

### Case 2: Append New Line (different scale)
**Input:**  
```
Component Name: WRANGLER
Scale: HIGH
View: Auction
Count: 4
```
**Result:**
```
Auction ; MID ; INGESTOR ; ETL ; vdopiasample = 4
Bid ; HIGH ; JOINER ; ETL ; vdopiasample-bid = 3
Auction ; LOW ; WRANGLER ; ETL ; vdopiasample = 4
Auction ; HIGH ; WRANGLER ; ETL ; vdopiasample = 4
```

---

### Case 3: Append Completely New Entry
**Input:**  
```
Component Name: VALIDATOR
Scale: HIGH
View: Auction
Count: 8
```
**Result:**
```
Auction ; MID ; INGESTOR ; ETL ; vdopiasample = 4
Bid ; HIGH ; JOINER ; ETL ; vdopiasample-bid = 3
Auction ; LOW ; WRANGLER ; ETL ; vdopiasample = 4
Auction ; HIGH ; WRANGLER ; ETL ; vdopiasample = 4
Auction ; HIGH ; VALIDATOR ; ETL ; vdopiasample = 8
```

---

## How to Run
1. Make the script executable:
   ```bash
   chmod +x updateconfig.sh
   ```
2. Run the script:
   ```bash
   ./updateconfig.sh
   ```
3. Follow the prompts to enter values.

---

## Features
- **Input validation** with case-insensitive matching.
- **Automatic case formatting** to required style.
- **Smart updating** — only modifies matching lines.
- **File creation** if `sig.conf` doesn’t exist.
- **Clear output messages** for each operation.

