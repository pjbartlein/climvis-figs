; ltmdiff_adj

mapvar = "psl" ; "hfls" ; "hfss" ; "rlnet" ; "rsnet" ; "rnet" ; "clt" ; 
outmap  = mapvar + "_AClim_CCSM4_midHolocene_ltmdiff_adj"

title_l = "CCSM4  SLP Long-term Mean Difference (Pa) "
level0 = new((/11/),float)
level0 = (/-200,-100,-50,-20,-10,0,10,20,50,100,200/)
level0begclr = 74
level0endclr = 85

; title_l = "CCSM4 Total Cloud Fraction Long-term Mean Diff. (%)"
; level0 = new((/11/),float)
; level0 = (/-20.0, -10.0, -5.0, -2.0, -1.0, 0, 1.0, 2.0, 5.0, 10.0, 20.0/)
; level0begclr = 86
; level0endclr = 97

; title_l = "CCSM4 Net Radiation Long-term Mean Diff. (W m~S~-2~N~)"
; level0 = new((/11/),float)
; level0 = (/-20,-10,-5,-2,-1,0,1,2,5,10,20/) 
; level0begclr = 30
; level0endclr = 45

ctrl_path = "/Users/bartlein/Dropbox/WorkCurrent/Calendar/data/nc_files/test03/ctrl/"
ctrl_file = mapvar + "_Aclim_CCSM4_piControl_r1i1p1_025001-130012-clim.nc"
exp_path = "/Users/bartlein/Dropbox/WorkCurrent/Calendar/data/nc_files/test03/adjusted/"
exp_file = mapvar + "_Aclim_CCSM4_midHolocene_r1i1p1_100001-130012-clim_cal_adj.nc"

title   = " "
title_r = "(midHolocene (Adjusted) - piControl)"
label1a = exp_file
label1b = ""

; shapefiles
land_dir = "/Users/bartlein/Dropbox/WorkCurrent/Calendar/data/comparisons/shp_files/CCSM4_midHolocene_land/"
land_file = "CCSM4_midHolocene_land.shp"
land_shp = land_dir + land_file
print(land_shp)
ice_dir = "/Users/bartlein/Dropbox/WorkCurrent/Calendar/data/comparisons/shp_files/CCSM4_midHolocene_ice/"
ice_file = "CCSM4_midHolocene_ice.shp"
ice_shp = ice_dir + ice_file
print(ice_shp)

months = (/"Jan", "Feb", "Mar", "Apr","May", "Jun",\
         "Jul", "Aug", "Sep", "Oct", "Nov","Dec" /)

; set color scale 
clr_map = "ClimA4"

begin

; open files and read data
f1 = addfile(exp_path + exp_file, "r")
exp_clim = f1->$mapvar$(:,:,:)
lon = f1->lon
lat = f1->lat
time = f1->time
exp_clim&lon       = lon
exp_clim&lat       = lat
exp_clim&time      = time
exp_clim = lonFlip(exp_clim)
printVarSummary(exp_clim)

f2 = addfile(ctrl_path + ctrl_file, "r")
clrl_clim = f2->$mapvar$(:,:,:)
lon = f2->lon
lat = f2->lat
time = f2->time
clrl_clim&lon       = lon
clrl_clim&lat       = lat
clrl_clim&time      = time
clrl_clim = lonFlip(clrl_clim)
printVarSummary(clrl_clim)

; climatologies (long-term means)
plot_var = (exp_clim - clrl_clim) 
copy_VarAtts(exp_clim, plot_var)
copy_VarCoords(exp_clim, plot_var)
printVarSummary(plot_var)

; output format ----------------------------------------------------------------
; wks_type = "pdf"
; wks_type@wkOrientation = "portrait"
wks_type = "png"
wks_type@wkWidth = 2048
wks_type@wkHeight = 2048

wks  = gsn_open_wks (wks_type, outmap)

plot = new(12,graphic)
id_land = new(12, graphic)
id_ice = new(12, graphic)

res = True 
;drawNDCGrid(wks)               ; Draw an NDC grid for reference.

; set colormap
gsn_define_colormap(wks,clr_map)

; gsn high-level interfaces ---------------------------------------------------
res@gsnDraw                = False              ; don't draw
res@gsnFrame               = False              ; don't advance frame
res@gsnSpreadColors        = True               ; use total colormap
 
; contour ----------------------------------------------------------------------
;res@gsnScalarContour      = True               ; contours desired
res@mpGridLineColor        = "transparent"      ; trick ncl into drawing perimeter
res@cnInfoLabelOn          = False              ; turn off cn info label
res@cnFillOn               = True               ; color fill  
res@cnLinesOn              = False              ; no contour lines
res@cnLineLabelsOn         = False              ; no contour labels
res@cnInfoLabelOn          = False              ; no contour info label
res@cnFillMode             = "CellFill"; "RasterFill" or "CellFill"
res@cnLevelSelectionMode   = "ExplicitLevels" ;

; maps -------------------------------------------------------------------------
res@mpOutlineOn            = False;     ; continental outline
res@mpFillOn               = False       ; turn off map fill
res@mpGridAndLimbOn        = True      ; Turn on lat/lon grid
res@mpPerimOn              = False      ; turn off perimeter  
res@mpProjection           = "Robinson"       ; choose map projection

res@mpGeophysicalLineColor = "black"    ; make outlines thicker
res@mpGeophysicalLineThicknessF = 4    ; make outlines thicker
;res@mpDataBaseVersion      = "MediumRes"     ; choose new outline database
res@mpLimbLineThicknessF    = 5
res@mpGridLatSpacingF       = 30
res@mpGridLonSpacingF       = 30 
res@mpGridLineColor         = "black"
res@mpGridLineThicknessF    = 2

res@mpLimitMode             = "LatLon" ; use lat/lon coordinates to limit area
res@mpMinLatF               =  -90. 
res@mpMaxLatF               =   90. 
res@mpMinLonF               =  -180. 
res@mpMaxLonF               =   180.

; label bar --------------------------------------------------------------------
res@lbLabelBarOn            = False             ; turn off individual cb's
res@pmLabelBarHeightF       = 0.06
res@lbLabelFontHeightF      = 0.0125
res@pmLabelBarOrthogonalPosF= -.002
res@lbBoxLineThicknessF     = 8
  
res@gsnSpreadColorStart     = level0begclr
res@gsnSpreadColorEnd       = level0endclr 
res@cnLevels                = level0 

; shapefile outlines -------------------------------------------------------
plres        = True
plres@gsLineColor = "black"
plres@gsLineThicknessF= 3
pires        = True
pires@gsLineColor = "black"
pires@gsLineThicknessF= 3

; plot()  ----------------------------------------------------------------------
res@gsnRightStringFontHeightF   = 0.025
res@gsnLeftStringFontHeightF    = 0.025    
res@gsnRightString          = ""            
res@gsnLeftString           = months(11) 

; plot(0): Dec 
plot(0) = gsn_csm_contour_map(wks,plot_var(11,:,:),res)  
id_land(0) = gsn_add_shapefile_polylines(wks,plot(0),land_shp,plres) ; add outlines
id_ice(0) = gsn_add_shapefile_polylines(wks,plot(0),ice_shp,pires)

; plot(1-11): Jan-Nov 
i = 0                                        
do nmo=0,10                                
    i = i+1
    res@gsnLeftString = months(nmo)
    plot(i) = gsn_csm_contour_map(wks,plot_var(nmo,:,:),res)  
    id_land(i) = gsn_add_shapefile_polylines(wks,plot(i),land_shp,plres)
    id_ice(i) = gsn_add_shapefile_polylines(wks,plot(i),ice_shp,pires)
end do

; titles ------------------------------------------------------------------------
txres1     = True
txres1@txFontHeightF = 0.015
txres1@txFont        = 21

txres1@txJust        = "topLeft" 
gsn_text_ndc(wks,title_l,0.055,0.98,txres1)
txres1@txJust        = "TopRight" 
gsn_text_ndc(wks,title_r,0.93,0.975,txres1)  
txres1@txJust        = "TopLeft" 
gsn_text_ndc(wks,label1a,0.055,0.2,txres1)
txres1@txJust        = "TopRight" 
gsn_text_ndc(wks,label1b,0.93,0.2,txres1) 

; plot panels ------------------------------------------------------------------
resP                        = True
resP@gsnPaperOrientation    = "portrait"   
resP@gsnPanelLeft           = 0.05
resP@gsnPanelRight          = 0.95 
resP@gsnPanelTop            = 0.95
resP@gsnPanelBottom         = 0.1  
resP@txFont                 = 21

; single label bar -------------------------------------------------------------
resP@gsnPanelLabelBar       = True 
resP@lbAutoManage           = False
resP@lbLabelFont            = 21
resP@lbLabelFontHeightF     = 0.01
resP@gsnPanelBottom         = 0.25
resP@lbLabelAutoStride      = True
resP@pmLabelBarParallelPosF = 0.005
resP@lbBoxLineThicknessF    = 4
resP@pmLabelBarWidthF       = 0.7     
resP@pmLabelBarHeightF      = 0.06     

; plot the panels --------------------------------------------------------------
gsn_panel(wks,plot,(/4,3/),resP)

end
exit()  
