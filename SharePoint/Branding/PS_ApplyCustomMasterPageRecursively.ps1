############################################################################################################################################
#This script allows to apply a custom master page recursively to all the sites defined in a site collection
#Required parametes:
#   ->$spSite: Site Collection Url
#   ->$sMasterUrl: Marte Page file
############################################################################################################################################
If ((Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue) -eq $null ) 
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell }

$host.Runspace.ThreadOptions = "ReuseThread"

#Definition of the function that applies the custom master page to all the sites in a site collection
function Apply-MasterPageToAllSites
{   
    try
    { 
        $spSite = Get-SPSite $sSiteUrl    
        $spsubWebs = $spSite.AllWebs    
        foreach($spsubWeb in $spsubWebs)
        {
            Write-Host "Applying custom master page to ($($spsubWeb.Url))" -foregroundcolor green
            $spsubWeb.MasterUrl= $sMasterUrl
            $spsubWeb.Update()
        }     
        $spSite.Dispose()
    }
    catch [System.Exception]
    {
        write-host -f red $_.Exception.ToString()
    }
}

Start-SPAssignment –Global
#Desaplicamos la página maestra
$sSiteUrl="http://<SiteCollectionUrl>"
$sMasterUrl="/_catalogs/masterpage/custom.master"
Apply-MasterPageToAllSites
Stop-SPAssignment –Global

Remove-PsSnapin Microsoft.SharePoint.PowerShell