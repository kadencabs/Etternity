-- Etterna Grade Mapping and Colors

function GetGradeString(grade)
    local g = grade
    if not g then return "" end
    if type(g) ~= "string" then g = ToEnumShortString(g) end
    
    -- Ensure we have the full Grade_ prefix if it's just the short string
    if not string.find(g, "Grade_") then
        g = "Grade_" .. g
    end

    local useMidGrades = PREFSMAN:GetPreference("UseMidGrades")

    local gradeStrings = {
        Grade_Tier01 = "AAAAA",
        Grade_Tier02 = useMidGrades and "AAAA:" or "AAAA",
        Grade_Tier03 = useMidGrades and "AAAA." or "AAAA",
        Grade_Tier04 = "AAAA",
        Grade_Tier05 = useMidGrades and "AAA:" or "AAA",
        Grade_Tier06 = useMidGrades and "AAA." or "AAA",
        Grade_Tier07 = "AAA",
        Grade_Tier08 = useMidGrades and "AA:" or "AA",
        Grade_Tier09 = useMidGrades and "AA." or "AA",
        Grade_Tier10 = "AA",
        Grade_Tier11 = useMidGrades and "A:" or "A",
        Grade_Tier12 = useMidGrades and "A." or "A",
        Grade_Tier13 = "A",
        Grade_Tier14 = "B",
        Grade_Tier15 = "C",
        Grade_Tier16 = "D",
        Grade_Tier17 = "D",
        Grade_Failed = "F",
        Grade_None   = "",
    }
    
    local res = gradeStrings[g] or ""
    return res
end

function GetGradeColor(grade)
    local g = grade
    if type(g) ~= "string" then g = ToEnumShortString(grade) end
    
    -- Ensure we have the full Grade_ prefix if it's just the short string
    if not string.find(g, "Grade_") then
        g = "Grade_" .. g
    end

    -- Etterna Til Death colors
    if g == "Grade_Tier01" then return color("#ffffff")     -- AAAAA
    elseif g == "Grade_Tier02" or g == "Grade_Tier03" or g == "Grade_Tier04" then return color("#66ccff") -- AAAA
    elseif g == "Grade_Tier05" or g == "Grade_Tier06" or g == "Grade_Tier07" then return color("#eebb00") -- AAA
    elseif g == "Grade_Tier08" or g == "Grade_Tier09" or g == "Grade_Tier10" then return color("#66cc66") -- AA
    elseif g == "Grade_Tier11" or g == "Grade_Tier12" or g == "Grade_Tier13" then return color("#da5757") -- A
    elseif g == "Grade_Tier14" then return color("#5b78bb") -- B
    elseif g == "Grade_Tier15" then return color("#c97bff") -- C
    elseif g == "Grade_Tier16" or g == "Grade_Tier17" then return color("#8c6239") -- D
    elseif g == "Grade_Failed" then return color("#cdcdcd") -- F
    end
    return color("#666666")
end
