{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit ACBrTCP;

interface

uses
  ACBrSocket, ACBrCEP, ACBrTCPReg, ACBrIBGE, ACBrCNIEE, ACBrSuframa, 
  ACBrDownload, ACBrDownloadClass, ACBrNFPws, ACBrConsultaCNPJ, ACBrIBPTax, 
  ACBrCotacao, ACBrMail, ACBrConsultaCPF, ACBrSpedTabelas, ACBrSedex, 
  ACBrMTer, ACBrMTerClass, ACBrMTerVT100, ACBrMTerStxEtx, ACBrMTerPMTG, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('ACBrTCPReg', @ACBrTCPReg.Register);
end;

initialization
  RegisterPackage('ACBrTCP', @Register);
end.
