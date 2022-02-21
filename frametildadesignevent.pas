unit FrameTildaDesignEvent;

{$mode Delphi}
{$H+}

interface

uses
	Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ValEdit,
	FrameTildaDesignEdit;

type
	{ TTildaDesignEventFrame }

	TTildaDesignEventFrame = class(TTildaDesignEditFrame)
	private
		procedure DoValidateProp(const AProp: string; const AOldValue: string;
				var ANewValue: string); override;
		procedure DoEditProp(const AProp: string; const AValue: string); override;
		procedure DoSetItem; override;

	public
		class procedure RegisterEditor; override;
	end;

implementation

{$R *.lfm}

uses
	TildaDesignTypes, TildaDesignClasses;

const
	ARR_LIT_EVENT_KIND: array[TTildaEventKind] of string = (
			'Prepare', 'Initialise', 'Change', 'Release', 'Present', 'Keypress');


{ TTildaDesignEventFrame }

procedure TTildaDesignEventFrame.DoValidateProp(const AProp: string;
		const AOldValue: string; var ANewValue: string);
	var
	k: TTildaEventKind;

	begin
	if  TTildaEvent(FItem).system then
		ANewValue:= AOldValue
	else if  CompareText(AProp, 'kind') = 0 then
		begin
		for k in TTildaEventKind do
			if  CompareStr(ARR_LIT_EVENT_KIND[k], ANewValue) = 0 then
				begin
				TTildaEvent(FItem).kind:= k;
				Exit;
				end;

		ANewValue:= AOldValue;
		end
	else
		inherited DoValidateProp(AProp, AOldValue, ANewValue);
	end;

procedure TTildaDesignEventFrame.DoEditProp(const AProp: string;
		const AValue: string);
	begin
	inherited DoEditProp(AProp, AValue);
	end;

procedure TTildaDesignEventFrame.DoSetItem;
	var
	k: TTildaEventKind;

	begin
	inherited DoSetItem;

	ValueListEditor1.Strings.Add('kind=' +
			ARR_LIT_EVENT_KIND[TTildaEvent(FItem).kind]);
	ValueListEditor1.ItemProps['kind'].EditStyle:= esPickList;
	for k in TTildaEventKind do
		ValueListEditor1.ItemProps['kind'].PickList.Add(ARR_LIT_EVENT_KIND[k]);
	end;

class procedure TTildaDesignEventFrame.RegisterEditor;
	begin
	TTildaDesignClass.Create(TTildaEvent, Self);
	end;


initialization
	TTildaDesignEventFrame.RegisterEditor;

end.

