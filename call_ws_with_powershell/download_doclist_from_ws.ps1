[String] $URL = 'http://host.mydomain.it:port/mypath/MyWsdlName?wsdl'

[String] $bodyDocList = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
   <soapenv:Header>
      ...
   </soapenv:Header>
   <soapenv:Body>
      ...
   </soapenv:Body>
</soapenv:Envelope>'

$headerDocList = @{
    "Content-Type" = "text/xml";
}

echo "sending request"
$responseDocList = Invoke-WebRequest -Uri $URL -Method Post -Body $bodyDocList -Headers $headerDocList

$xmlresponseDocList = [xml]$responseDocList.content

$DocumentsList = New-Object System.Collections.ArrayList

FOREACH ($docName in $xmlresponseDocList.Envelope.Body.documentiListResponse.documenti.nome){
    $DocumentsList.Add($docName) > $null
}

$DocumentsIdList = New-Object System.Collections.ArrayList

FOREACH ($docId in $xmlresponseDocList.Envelope.Body.documentiListResponse.documenti.identificativo.identificativoDocumento){
    $DocumentsIdList.Add($docId) > $null
}

echo $DocumentsIdList
echo $DocumentsIdList[0]