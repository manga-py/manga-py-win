function Get-HiddenImportParameters {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Directory,

        [Parameter(Mandatory)]
        [string] $NamespacePrefix
    )
    $ignoreList = @('__init__', '_template')
    Get-ChildItem $Directory | ? { $_.Extension -eq '.py' } | % { $_.BaseName } | ? { -Not $ignoreList.Contains($_) } | % { "--hidden-import `"$NamespacePrefix.$_`"" }
}