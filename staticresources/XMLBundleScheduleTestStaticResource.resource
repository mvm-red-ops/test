<tvo:OrderIdReferences>
<tvc:SourceCode source="Agency">National</tvc:SourceCode>
<tvc:SourceCode source="Rep"></tvc:SourceCode>
</tvo:OrderIdReferences>

<tvo:AltOrderIdReferences>
<tvc:SourceCode source="Agency"></tvc:SourceCode>
</tvo:AltOrderIdReferences>

<tvo:OrderType>Normal</tvo:OrderType>
<tvo:OrderCashTrade>Cash</tvo:OrderCashTrade>

<tvm:Advertiser>
<tvc:CompanyName>TestAdvertiser</tvc:CompanyName>
<tvc:SourceCode source="Agency"></tvc:SourceCode>
</tvm:Advertiser>

<tvm:Product>
<tvm:ProductName>Test Brand</tvm:ProductName>
<tvc:SourceCode source="Agency"></tvc:SourceCode>
</tvm:Product>

<tvm:Agency>
<tvc:CompanyName>Test Account c/o Marathon</tvc:CompanyName>
<tvc:Address addressRole="Billing">
<tvc:Street1>675 Third Avenue, 11th Floor</tvc:Street1>
<tvc:City>New York</tvc:City>
<tvc:RegionCode>NY</tvc:RegionCode>
<tvc:PostalCode>10017</tvc:PostalCode>
<tvc:CountryCode></tvc:CountryCode>
</tvc:Address>

<tvc:Contact contactRole="Buyer">
<tvc:PersonFirstName>Tania</tvc:PersonFirstName>
<tvc:PersonLastName>Bonetti</tvc:PersonLastName>
<tvc:Email></tvc:Email>
<tvc:Phone></tvc:Phone>
</tvc:Contact>

<tvc:SourceCode source="Station">00000000-0000-0000-0000-000000000000</tvc:SourceCode>
<tvc:Office>
<tvc:OfficeName>Test Account c/o Marathon</tvc:OfficeName>
<tvc:SourceCode source="Agency">00000000-0000-0000-0000-000000000000</tvc:SourceCode>
</tvc:Office>
</tvm:Agency>

<tvm:Estimate>
<tvc:SourceCode source="Agency">National</tvc:SourceCode>
</tvm:Estimate>

<tvm:Seller>
<tvm:StationSeller>
<tvc:CompanyName>WMUR - Manchester - Hearst</tvc:CompanyName>
<tvc:Contact contactRole="AccountExec">
<tvc:PersonFirstName>Joe</tvc:PersonFirstName>
<tvc:PersonLastName>Smith</tvc:PersonLastName>
<tvc:Email></tvc:Email>
<tvc:Phone></tvc:Phone>
</tvc:Contact>
<tvc:SourceCode source="Station">00000000-0000-0000-0000-000000000000</tvc:SourceCode>
<tvc:Office>
<tvc:OfficeName>Marathon</tvc:OfficeName>
<tvc:SourceCode source="Agency">00000000-0000-0000-0000-000000000000</tvc:SourceCode>
</tvc:Office>
</tvm:StationSeller>
</tvm:Seller>

<tvo:LocalNational>National</tvo:LocalNational>
<tvm:Station>
<tvm:FCCCallLetters>WMUR</tvm:FCCCallLetters>
<tvc:SourceCode source="Station">00000000-0000-0000-0000-000000000000</tvc:SourceCode>
</tvm:Station>

<tvc:StartDate>2015-09-28</tvc:StartDate>
<tvc:EndDate>2015-10-04</tvc:EndDate>
<tvo:OrderGrossAmount>60.00</tvo:OrderGrossAmount>
<tvo:BillingCalendar>Broadcast</tvo:BillingCalendar>
<tvo:BillingCycle>Monthly</tvo:BillingCycle>
<tvm:PrimaryDemoCategory demoId="DM0" />
<tvm:DemoCategory demoId="DM0">
<tvm:DemoGroup>Adults</tvm:DemoGroup>
<tvm:DemoLowerAge>18</tvm:DemoLowerAge>
<tvm:DemoUpperAge>99</tvm:DemoUpperAge>
</tvm:DemoCategory>
<tvc:Comment source="Agency"></tvc:Comment>

<tvo:Buylines>

<tvo:SpotBuyline buylineNumber="1" buylineVersion="1" buylineStatus="New">
<tvo:BuylineIdReferences>
<tvc:SourceCode source="Agency"></tvc:SourceCode>
</tvo:BuylineIdReferences>

<tvo:BuylineCashTrade>Cash</tvo:BuylineCashTrade>
<tvo:BuylineDescription>Sign-On/Sign-Off</tvo:BuylineDescription>
<tvc:StartDate>2015-09-28</tvc:StartDate>
<tvc:EndDate>2015-10-04</tvc:EndDate>
<tvo:BuylineQuantity unitType="Spot">2</tvo:BuylineQuantity>
<tvo:BuylineUnitRate costModel="Unit">30.00</tvo:BuylineUnitRate>
<tvo:BuylineGrossAmount>60.00</tvo:BuylineGrossAmount>
<tvc:Comment source="Agency"></tvc:Comment>
<tvo:SpotBuylineType>Normal</tvo:SpotBuylineType>
<tvo:SpotLength>60</tvo:SpotLength>
<tvm:StartDayOfWeek>Mo</tvm:StartDayOfWeek>

<tvo:ContractInterval>
<tvm:MondayValid>True</tvm:MondayValid>
<tvm:TuesdayValid>True</tvm:TuesdayValid>
<tvm:WednesdayValid>True</tvm:WednesdayValid>
<tvm:ThursdayValid>True</tvm:ThursdayValid>
<tvm:FridayValid>True</tvm:FridayValid>
<tvm:SaturdayValid>True</tvm:SaturdayValid>
<tvm:SundayValid>True</tvm:SundayValid>
<tvc:StartTime>1:00</tvc:StartTime>
<tvc:EndTime>6:00</tvc:EndTime>
</tvo:ContractInterval>

<tvo:WeeklySpotDistribution>
<tvc:StartDate>2015-09-28</tvc:StartDate>
<tvc:EndDate>2015-10-04</tvc:EndDate>
<tvo:SpotPerWeekQuantity>2</tvo:SpotPerWeekQuantity>
<tvm:MondayValid>True</tvm:MondayValid>
<tvm:TuesdayValid>True</tvm:TuesdayValid>
<tvm:WednesdayValid>True</tvm:WednesdayValid>
<tvm:ThursdayValid>True</tvm:ThursdayValid>
<tvm:FridayValid>True</tvm:FridayValid>
<tvm:SaturdayValid>True</tvm:SaturdayValid>
<tvm:SundayValid>True</tvm:SundayValid>
</tvo:WeeklySpotDistribution>
</tvo:SpotBuyline>

</tvo:Buylines>
</tvo:Order>
</tvo:CreateOrderRequest>
