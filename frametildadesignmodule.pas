unit FrameTildaDesignModule;

{$mode Delphi}
{$H+}

interface

uses
	Classes, SysUtils, Forms, Controls, Graphics, Dialogs, FrameTildaDesignEdit;

type

	{ TTildaDesignModuleFrame }

	TTildaDesignModuleFrame = class(TTildaDesignEditFrame)
	private
	protected
		procedure DoValidateProp(const AProp: string; const AOldValue: string;
			var ANewValue: string); override;
		procedure DoEditProp(const AProp: string; const AValue: string); override;
		procedure DoSetItem; override;
	public

	end;

implementation

{$R *.lfm}

uses
	TildaDesignTypes;

{ TTildaDesignModuleFrame }

procedure TTildaDesignModuleFrame.DoValidateProp(const AProp: string;
		const AOldValue: string; var ANewValue: string);
	begin
	if  CompareText(AProp, 'name') = 0 then
		begin
		if  Length(ANewValue) < 16 then
			ANewValue:= ANewValue + StringOfChar(' ', 16);

		if  Length(ANewValue) > 16 then
			ANewValue:= Copy(ANewValue, Low(string), 16);
		end
	else
		inherited DoValidateProp(AProp, AOldValue, ANewValue);
	end;

procedure TTildaDesignModuleFrame.DoEditProp(const AProp: string;
		const AValue: string);
	begin
	if  CompareText(AProp, 'name') = 0 then
		TTildaModule(FItem).name:= AValue
	else
		inherited DoEditProp(AProp, AValue);
	end;

procedure TTildaDesignModuleFrame.DoSetItem;
	begin
	inherited DoSetItem;

	ValueListEditor1.Strings.Add('name=' + TTildaModule(FItem).name);
	ValueListEditor1.ItemProps['name'].MaxLength:= 16;
	end;

end.

