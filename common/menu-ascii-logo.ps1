function Show-Ascii {
  [CmdletBinding()]
  param (
      [Parameter(Mandatory)]
      [string]$Title,
      [string]$SubTitle
  )

  return @"

    $Title
      ~ $SubTitle ~
    _______________
    ,===:'.,            `-._
         `:.`---.__         `-._
           `:.     `--.         `.
             \.        `.         `.
     (,,(,    \.         `.   ____,-`.,
  (,'     `/   \.   ,--.___`.'
,  ,'  ,--.  `,   \.;'         `
`{D, {    \  :    \;
 V,,'    /  /    //
 j;;    /  ,' ,-//.    ,---.      ,
 \;'   /  ,' /  _  \  /  _  \   ,'/
       \   `'  / \  `'  / \  `.' /
        `.___,'   `.__,'   `.__,'  


"@
}