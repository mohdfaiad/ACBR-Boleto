object frlDANFeRL: TfrlDANFeRL
  Left = 944
  Height = 634
  Top = 336
  Width = 810
  Caption = 'frlDANFeLR'
  ClientHeight = 634
  ClientWidth = 810
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  Position = poMainFormCenter
  LCLVersion = '1.2.6.0'
  object RLNFe: TRLReport
    Left = 0
    Height = 1123
    Top = 0
    Width = 794
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    PreviewOptions.ShowModal = True
    PreviewOptions.Caption = 'DANFe'
    RealBounds.Left = 0
    RealBounds.Top = 0
    RealBounds.Width = 0
    RealBounds.Height = 0
    ShowProgress = False
  end
  object RLPDFFilter1: TRLPDFFilter
    DocumentInfo.Author = 'FortesReport 3.23 - Copyright © 1999-2009 Fortes Informática'
    DocumentInfo.Creator = 'Projeto ACBr (Componente NF-e)'
    DocumentInfo.ModDate = 0
    ViewerOptions = []
    FontEncoding = feNoEncoding
    DisplayName = 'Documento PDF'
    left = 368
    top = 152
  end
  object DataSource1: TDataSource
    left = 400
    top = 152
  end
end
