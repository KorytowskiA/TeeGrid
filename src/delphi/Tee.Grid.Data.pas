{*********************************************}
{  TeeGrid Software Library                   }
{  Abstract TVirtualData class                }
{  Copyright (c) 2016 by Steema Software      }
{  All Rights Reserved                        }
{*********************************************}
unit Tee.Grid.Data;
{$I Tee.inc}

interface

{
  Base abstract TVirtualData class.

  Provides data to a TeeGrid (main rows or sub-rows)

  See concrete implementations at the following units:

  Tee.Grid.Data.Rtti     (for generic TArray<T> or TList<T> data)
  Tee.Grid.Data.DB       (for TDataSet and TDataSource)
  Tee.Grid.Data.Strings  (to emulate a TStringGrid with Cells[Col,Row] property)

  BI.Grid.Data           (for any TeeBI TDataItem data structure)

}

uses
  {System.}Classes,
  Tee.Grid.Columns, Tee.Painter, Tee.Renders;

type
  TFloat=Double;

  TRowChangedEvent=procedure(const Sender:TObject; const ARow:Integer) of object;

  TColumnCalculation=(Count,Sum,Min,Max,Average);

  TVirtualData=class abstract
  protected
    FOnChangeRow : TRowChangedEvent;
    FOnRepaint,
    FOnRefresh : TNotifyEvent;

    PictureClass : TPersistentClass;

    class function Add(const AColumns:TColumns; const AName:String; const ATag:TObject):TColumn; overload; static;

    procedure ChangeSelectedRow(const ARow:Integer);

    class procedure DoError(const AText:String); static;

    procedure Refresh;
    procedure RowChanged(const ARow:Integer); virtual;
    procedure Repaint;

    function SampleDate(const AColumn:TColumn): String;
    function SampleDateTime(const AColumn:TColumn):String;
    function SampleTime(const AColumn:TColumn):String;
  public
    procedure AddColumns(const AColumns:TColumns); virtual; abstract;
    function AsFloat(const AColumn:TColumn; const ARow:Integer):TFloat; virtual;
    function AsString(const AColumn:TColumn; const ARow:Integer):String; virtual; abstract;
    function AutoWidth(const APainter:TPainter; const AColumn:TColumn):Single; virtual; abstract;
    function Calculate(const AColumn:TColumn; const ACalculation:TColumnCalculation):TFloat;
    function CanExpand(const Sender:TRender; const ARow:Integer):Boolean; virtual;
    function CanSortBy(const AColumn:TColumn):Boolean; virtual;
    function Count:Integer; virtual; abstract;
    class function From(const ASource:TComponent):TVirtualData; overload; virtual;
    function GetDetail(const ARow:Integer; const AColumns:TColumns; out AParent:TColumn):TVirtualData; virtual;
    function HasDetail(const ARow:Integer):Boolean; virtual;
    class function IsNumeric(const AColumn:TColumn):Boolean; overload; virtual;
    function IsSorted(const AColumn:TColumn; out Ascending:Boolean):Boolean; virtual;
    procedure Load; virtual; abstract;
    function LongestString(const APainter:TPainter; const AColumn:TColumn):Single;
    function ReadOnly(const AColumn:TColumn):Boolean; virtual;
    procedure SetValue(const AColumn:TColumn; const ARow:Integer; const AText:String); virtual; abstract;
    procedure SortBy(const AColumn:TColumn); virtual;
  end;

  TVirtualDataClass=class of TVirtualData;

  TVirtualDataClasses=record
  private
    class var
      Items : Array of TVirtualDataClass;

    class function IndexOf(const AClass:TVirtualDataClass):Integer; static;
  public
    class function Guess(const ASource:TComponent):TVirtualData; static;
    class procedure Register(const AClass:TVirtualDataClass); static;
    class procedure UnRegister(const AClass:TVirtualDataClass); static;
  end;

implementation
