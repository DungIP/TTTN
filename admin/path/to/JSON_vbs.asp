<%
Function JSON_Parse(jsonString)
    Dim objJSON
    Set objJSON = CreateObject("Scripting.Dictionary")
    
    Dim currentPosition
    currentPosition = 1
    
    ' Skip whitespace characters
    While Mid(jsonString, currentPosition, 1) = " " Or Mid(jsonString, currentPosition, 1) = vbTab
        currentPosition = currentPosition + 1
    Wend
    
    ' Parse JSON object
    If Mid(jsonString, currentPosition, 1) = "{" Then
        currentPosition = currentPosition + 1
        
        While Mid(jsonString, currentPosition, 1) <> "}"
            ' Skip whitespace characters
            While Mid(jsonString, currentPosition, 1) = " " Or Mid(jsonString, currentPosition, 1) = vbTab
                currentPosition = currentPosition + 1
            Wend
            
            ' Parse key
            Dim key
            key = JSON_ParseValue(jsonString, currentPosition)
            
            ' Skip whitespace characters
            While Mid(jsonString, currentPosition, 1) = " " Or Mid(jsonString, currentPosition, 1) = vbTab
                currentPosition = currentPosition + 1
            Wend
            
            ' Check for colon separator
            If Mid(jsonString, currentPosition, 1) <> ":" Then
                Exit Function ' Invalid JSON syntax
            End If
            
            currentPosition = currentPosition + 1
            
            ' Skip whitespace characters
            While Mid(jsonString, currentPosition, 1) = " " Or Mid(jsonString, currentPosition, 1) = vbTab
                currentPosition = currentPosition + 1
            Wend
            
            ' Parse value
            Dim value
            value = JSON_ParseValue(jsonString, currentPosition)
            
            ' Add key-value pair to the dictionary
            objJSON(key) = value
            
            ' Skip whitespace characters
            While Mid(jsonString, currentPosition, 1) = " " Or Mid(jsonString, currentPosition, 1) = vbTab
                currentPosition = currentPosition + 1
            Wend
            
            ' Check for comma separator
            If Mid(jsonString, currentPosition, 1) = "," Then
                currentPosition = currentPosition + 1
            End If
        Wend
        
        currentPosition = currentPosition + 1
    End If
    
    Set JSON_Parse = objJSON
    Set objJSON = Nothing
End Function

Function JSON_ParseValue(jsonString, currentPosition)
    Dim value
    
    ' Skip whitespace characters
    While Mid(jsonString, currentPosition, 1) = " " Or Mid(jsonString, currentPosition, 1) = vbTab
        currentPosition = currentPosition + 1
    Wend
    
    ' Check for string value
    If Mid(jsonString, currentPosition, 1) = """" Then
        currentPosition = currentPosition + 1
        
        Dim stringValue
        stringValue = ""
        
        While Mid(jsonString, currentPosition, 1) <> """"
            If Mid(jsonString, currentPosition, 1) = "\" Then
                currentPosition = currentPosition + 1
                
                ' Handle escaped characters
                Select Case Mid(jsonString, currentPosition, 1)
                    Case "b"
                        stringValue = stringValue & vbBack
                    Case "f"
                        stringValue = stringValue & vbFormFeed
                    Case "n"
                        stringValue = stringValue & vbLf
                    Case "r"
                        stringValue = stringValue & vbCr
                    Case "t"
                        stringValue = stringValue & vbTab
                    Case Else
                        stringValue = stringValue & Mid(jsonString, currentPosition, 1)
                End Select
            Else
                stringValue = stringValue & Mid(jsonString, currentPosition, 1)
            End If
            
            currentPosition = currentPosition + 1
        Wend
        
        currentPosition = currentPosition + 1
        value = stringValue
    Else
        ' Check for numeric value
        Dim numericValue
        numericValue = ""
        
        While InStr("0123456789.", Mid(jsonString, currentPosition, 1)) > 0
            numericValue = numericValue & Mid(jsonString, currentPosition, 1)
            currentPosition = currentPosition + 1
        Wend
        
        If InStr(numericValue, ".") > 0 Then
            value = CDbl(numericValue)
        Else
            value = CLng(numericValue)
        End If
    End If
    
    JSON_ParseValue = value
End Function

Function JSON_Stringify(objJSON)
    Dim jsonString, key
    jsonString = "{"
    For Each key In objJSON.Keys
        jsonString = jsonString & """" & key & """: """ & objJSON(key) & ""","
    Next
    jsonString = Left(jsonString, Len(jsonString) - 1) ' Remove the trailing comma
    jsonString = jsonString & "}"
    JSON_Stringify = jsonString
End Function
%>