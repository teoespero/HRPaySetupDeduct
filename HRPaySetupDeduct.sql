/*
	
	HRPaySetupDeduct
	The HRPaySetupDeduct defines the deductions that an employee has, including vendor, optional warrant description, amount or percent and a goal.

*/

select 
	DistrictID,
	rtrim(DistrictAbbrev) as DistrictAbbrev,
	DistrictTitle
from tblDistrict

select 
	(select DistrictId from tblDistrict) as OrgId,
	te.EmployeeID as EmpId,
	CONVERT(VARCHAR(10), eff.StartDate, 110) as DateFrom,
	null as DateThru,
	null as DeductId,
	dplan.VendorId as VendorId,
	ven.DefaultPurchasingAddressId as VendorAddrId,
	pol.[policy] as Descr,
	pdt.amount as DeductAmt,
	null as DeductAmtGoal,
	null as OverridePrds,
	wht.[Description],
	dplan.Id,
	dplan.DeductionPlan,
	pol.[Policy],
	pdt.Amount as PolicyAmt,
	pdt.DistrictAmount as DistAmount
from tblEmployee te
left join
	PyDeductionTemplate pdt
	on pdt.EmployeeId = te.EmployeeID
	and pdt.InactivePayrollId is null
	and te.TerminateDate is null
left join
	PyDeductionPolicy pol
	on pol.Id = pdt.PyDeductionPolicyId
left join
	PyDeductionPlan dplan
	on dplan.Id = pol.PyDeductionPlanId
left join
	tblPayroll eff
	on eff.PayrollID = pdt.EffectivePayrollId
inner join
	Vendor ven
	on dplan.VendorId = ven.Id
inner join
	DS_Global..PyWithholdingType wht
	on wht.Id = dplan.PyDeductionTypeId

