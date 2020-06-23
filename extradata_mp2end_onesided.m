clear all
close all

NumberofRuns=5;

NumberofMotors=15;

kOn=1; %Chance of a single motor falling on filament. true kOn is kOn*NumberofFreeMotors*LengthofFilament
kOff=100;
kWalk=1; %Chance of a single motor walking on filament. true kWalk is kOn*NumberofBoundMotors

LengthofFilamentArray=[5 10 15 25 30];

BoundOverTimeCell=cell(NumberofRuns, size(LengthofFilamentArray,2));
OnOffWalkCell=cell(NumberofRuns, size(LengthofFilamentArray,2));
DTCell=cell(NumberofRuns, size(LengthofFilamentArray,2));
DisplacementCell=cell(NumberofRuns, size(LengthofFilamentArray,2));


for h=1:NumberofRuns
 
    for i=1:size(LengthofFilamentArray,2)
    
    %---INITIALIZING Values (Reset after each depolymerizing event)

        LengthofFilament=LengthofFilamentArray(i);

        NumberofMonomers=LengthofFilament+1;

        MotorTrackingMatrix=zeros(NumberofMotors,5);
        MotorTrackingMatrix(:,1)=(1:NumberofMotors); %first row is the motor number, second is the time it landed, the third is its current position
        %first column is the motor number, second is the time it landed, the third
        %is position it landed in, fourth is current position, fifth is time it
        %reached end

        MotorFellOff=0;

        DT=[0];

        TotalSteps=0;

        WalkSteps=0;

        BoundOverTime=0;
        OnOffWalk=0;
        DT=0;

        j=0;

        %--------------------------------------------------------------------------


        while MotorFellOff<NumberofMotors


        %---Setting Rates----------------------------------------------------------

            if sum(MotorTrackingMatrix(:,4)==0)>0 && sum(MotorTrackingMatrix(:,4)==NumberofMonomers)==0 %If there are any free motors and no motors on end
                k1=kOn*sum(MotorTrackingMatrix(:,4)==0)*LengthofFilament; %kOn times number of free motors times length of filament
            else
                k1=0;
            end

            if sum(MotorTrackingMatrix(:,4)==NumberofMonomers)>0
                k2=kOff;
            else
                k2=0;
            end

            if sum(MotorTrackingMatrix(:,4)>0)>0 && sum(MotorTrackingMatrix(:,4)==NumberofMonomers)==0 % If there is a protein anywhere on the filament and there are no proteins on end
                k3=kWalk*sum(MotorTrackingMatrix(:,4)>0); %kWalk * The number of bound motors
            else
                k3=0;
            end

            kTotal=k1+k2+k3;

        %---Outcomes (Land, Walk, Off)---------------------------------------------

            p=rand;
        %     DT=[DT exprnd(1/kTotal)];
            j=j+1;
            DT(j)=exprnd(1/kTotal);

            if p<k1/kTotal
                FreeMotorArray=find(MotorTrackingMatrix(:,4)==0); %gives an array of the indexes of every free motor
                LandPosition=ceil(p*NumberofMonomers); %Which position "bin" the number falls into
                MotorToLand=FreeMotorArray(ceil((LandPosition-p*NumberofMonomers)*size(FreeMotorArray,1))); %Splits the "position bin" into bins for free motors & finds where p falls

                MotorTrackingMatrix(MotorToLand,2)=sum(DT); %Time Landed
                MotorTrackingMatrix(MotorToLand,3)=LandPosition; %Position Landed
                MotorTrackingMatrix(MotorToLand,4)=LandPosition; %Current Position
                Outcome=1;
            else
                if p>k1/kTotal && p<(k1+k2)/kTotal
                    MotorFellOff=MotorFellOff+1;
                    Outcome=2;
                    MotorTrackingMatrix(find(MotorTrackingMatrix(:,4)==NumberofMonomers),5)=sum(DT)
                    MotorTrackingMatrix(find(MotorTrackingMatrix(:,4)==NumberofMonomers),4)=-NumberofMonomers; %the motor is no longer counted as a "free" (0) or "bound" (>0) motor
%                     DT(end)=[]; %eliminates kOff time

                else
                    BoundMotorArray=find(MotorTrackingMatrix(:,4)>0);
                    q=p-(k1+k2)/kTotal; %This is how far p is away from the edge of the "walk bin"
                    WalkInteger=ceil(q*size(BoundMotorArray,1)*2);
                    MotorToWalk=BoundMotorArray(ceil(WalkInteger/2)); %Does this make the higher indexed motors more likely to walk?
                    WalkSteps=[WalkSteps DT(end)]; %adds the amount of time this walk step took

                        if mod(WalkInteger,2)~=0 && MotorTrackingMatrix(MotorToWalk,4)~=1 %whether or not its even or odd
                            WalkDirection=-1;
                        else
                            WalkDirection=1;
                        end

                    MotorTrackingMatrix(MotorToWalk,4)=MotorTrackingMatrix(MotorToWalk,4)+WalkDirection; %Current Position either forward or back
                    Outcome=3;
                end
            end 

            BoundOverTime(j)=size(MotorTrackingMatrix(MotorTrackingMatrix(:,4)>0),1);
            OnOffWalk(j)=Outcome;
            
            MotorTrackingMatrix


        end

        TotalTimeMatrix(h,i)=sum(DT); %how much time this run took in total

        TerminalProtein=MotorTrackingMatrix((MotorTrackingMatrix(:,5)==(min(MotorTrackingMatrix(:,5)))));

        Displacement=NumberofMonomers-[MotorTrackingMatrix(TerminalProtein,3) MotorTrackingMatrix(:,3)']; % First entry is displacement of terminal protein, rest is the final position-original position for all proteins in order (terminal protein included)
        TimeOnFilament=[(MotorTrackingMatrix(TerminalProtein,5)-MotorTrackingMatrix(TerminalProtein,2)) (MotorTrackingMatrix(:,5)-MotorTrackingMatrix(:,2))']; %first entry is time terminal protein spent on filament, rest is all in order
        
        BoundOverTimeCell{h,i}=BoundOverTime;
        OnOffWalkCell{h,i}=OnOffWalk;
        DTCell{h,i}=DT;
        DisplacementCell{h,i}=Displacement;
        StartingPositionCell{h,i}=MotorTrackingMatrix(:,3);
        StartingTimeCell{h,i}=MotorTrackingMatrix(:,2);
        EndingTimeCell{h,i}=MotorTrackingMatrix(:,5);

        TimeOnFilamentCell{h,i}=TimeOnFilament; %How long all proteins on the filament, including falling off
        
        
    end
end
  
    
for h=1:NumberofRuns


    for i=1:size(LengthofFilamentArray,2)

        TotalTime(h,i)=sum(DTCell{h,i});

        DisplacementTemp=DisplacementCell{h,i};
        TPDisplacement(h,i)=DisplacementTemp(1); %Displacement of protein that eventually reaches end
        DisplacementTemp(1)=[];
        AvgDisplacement(h,i)= mean(DisplacementTemp); %Average Displacement of all proteins for this run
        
        TimeOnFilamentTemp=TimeOnFilamentCell{h,i};
        TPTimeOnFilament(h,i)=TimeOnFilamentTemp(1); %TimeOnFilament of protein that eventually reaches end
        TimeOnFilamentTemp(1)=[];
        AvgTimeOnFilament(h,i)= mean(TimeOnFilamentTemp); %Average time on filament of all proteins for this run


        On=(OnOffWalkCell{h,i}==1);
        Walk=(OnOffWalkCell{h,i}==3);

        BoundOverTimeTemp=BoundOverTimeCell{h,i};

        TotalOnSteps(h,i)=size(BoundOverTimeTemp(On),2);
        TotalWalkSteps(h,i)=size(BoundOverTimeTemp(Walk),2);

        DTTemp=DTCell{h,i};
        TotalOnTime(h,i)=sum(DTTemp(On));
        TotalWalkTime(h,i)=sum(DTTemp(Walk));


    end

end


% 
% 
% 
% x=LengthofFilamentArray;
% 
% 
% %Calculate Diffusion Constant
% 
% DiffCon=1/(2*mean(mean(TotalWalkTime,1)./mean(TotalWalkSteps,1))); % 1/ (2* The mean of The average time spent walking divided by the average walk steps for multiple lengths)
% %-----------------------------------
% 
% parameters=join({'Runs=' num2str(NumberofRuns); 'Total Proteins=' num2str(NumberofMotors); 'kOn=' num2str(kOn); 'kWalk=' num2str(kWalk); 'kOff=' num2str(kOff); 'Filament Lengths=' num2str(LengthofFilamentArray); 'Diffusion Constant=' num2str(DiffCon)})
% 
% 
% figure(1) %Total Time Versus Length
% 
% totaltimeplot=plot(x,mean(TotalTime,1), 'm')
% totaltimeplot.LineWidth=3
% totaltimeplot.DisplayName='Simulation Data'
% 
% hold on
% 
% totaltimetheory=LengthofFilamentArray.^2./(3*DiffCon)+1/(kOn*NumberofMotors)+1/kOff;
% totaltimetheoryplot=plot(x,totaltimetheory,'c:')
% totaltimetheoryplot.LineWidth=3
% totaltimetheoryplot.DisplayName='Theory, D=(avg time spent walking)/(avg # of walk steps), T= L^2/(3*D)+1/(kOn*N)+1/kOff'
% 
% hold on % This is the same theory but using the diffusion constant 0.5 instead of the one we calculate
% 
% totaltimetheoryD=LengthofFilamentArray.^2./(3*0.5)+1/(kOn*NumberofMotors)+1/kOff;
% totaltimetheoryDplot=plot(x,totaltimetheoryD,'g:')
% totaltimetheoryDplot.LineWidth=3
% totaltimetheoryDplot.DisplayName='Theory, D=0.5'
% 
% xlabel('Length (in Monomers) of Filament')
% ylabel('Time Until One Protein Reaches The End and Depolymerizes')
% title('Single Protein, Length Versus Time until Depolymerization Event', 'FontSize',14)
% set(gca, 'fontsize',20)
% 
% legend show
% 
% an=annotation('textbox', [0.25, 0.5, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on') %text box horizontally offset (from left) 25% of figure's width & vertically offset (from bottom) 50%. Box fits around text. Default Height is 10% of height x 10% width
% an.FontSize=14
% 
% figure(2) %Displacement of terminal protein and all proteins
% 
% tpdisplacementplot=plot(x,mean(TPDisplacement,1), 'm')
% tpdisplacementplot.LineWidth=3
% tpdisplacementplot.DisplayName='Protein That Reaches End'
% 
% hold on
% 
% avgdisplacementplot=plot(x,mean(AvgDisplacement,1), 'c')
% avgdisplacementplot.LineWidth=3
% avgdisplacementplot.DisplayName='All Proteins' %should I index proteins with 0 displacement differently than proteins that never land?
% 
% xlabel('Length (in Monomers) of Filament')
% ylabel('Average Total Displacement of Proteins')
% title('Average Total Displacement of Proteins Versus Length', 'FontSize',14)
% set(gca, 'fontsize',20)
% 
% legend show
% 
% an=annotation('textbox', [0.25, 0.5, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on') %text box horizontally offset (from left) 25% of figure's width & vertically offset (from bottom) 50%. Box fits around text. Default Height is 10% of height x 10% width
% an.FontSize=14
% 
% figure(3) %Single Protein Time Versus Length
% 
% tptimeonfilamentplot=plot(x,mean(TPTimeOnFilamentMatrix,1), 'm')
% tptimeonfilamentplot.LineWidth=3
% tptimeonfilamentplot.DisplayName='Simulation Averages' 
% 
% xlabel('Length (in Monomers) of Filament')
% ylabel('Time Terminal Protein Spends On Filament')
% title('Time Terminal Protein Spends On Filament Versus Length', 'FontSize',14)
% set(gca, 'fontsize',20)
% 
% hold on
% 
% tptimeonfilamenttheoryplot=plot(x, LengthofFilamentArray.^2./(3*DiffCon), 'c:')
% tptimeonfilamenttheoryplot.LineWidth=3
% tptimeonfilamenttheoryplot.DisplayName= 'Theory, D=(avg time spent walking)/(avg # of walk steps), Time=L^2/(3*D)'
% 
% hold on %This is using D=0.5 instead of the calculated Diffcon
% 
% tptimeonfilamenttheoryDplot=plot(x, LengthofFilamentArray.^2./(3*0.5), 'g:')
% tptimeonfilamenttheoryDplot.LineWidth=3
% tptimeonfilamenttheoryplotD.DisplayName= 'Theory, D=0.5'
% 
% 
% legend show
% 
% an=annotation('textbox', [0.25, 0.5, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on') %text box horizontally offset (from left) 25% of figure's width & vertically offset (from bottom) 50%. Box fits around text. Default Height is 10% of height x 10% width
% an.FontSize=14
% 
% figure(4) % Total number of walk steps versus time
% 
% yyaxis right
% totalwalkstepsplot=plot(x,mean(TotalWalkSteps,1), 'm')
% totalwalkstepsplot.LineWidth=3
% totalwalkstepsplot.DisplayName='Average Walk Steps'
% 
% hold on
% 
% yyaxis left
% totalwalktimeplot=plot(x,mean(TotalWalkTime,1), 'm:')
% totalwalktimeplot.LineWidth=3
% totalwalktimeplot.DisplayName='Total Time Spent Walking'
% 
% xlabel('Length (in Monomers) of Filament')
% ylabel('Time (Left) and Number of Steps (Right)')
% title('Number of Walking Steps and Time Spent Walking Versus Length', 'FontSize',14)
% set(gca, 'fontsize',20)
% 
% legend show
% 
% an=annotation('textbox', [0.25, 0.5, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on') %text box horizontally offset (from left) 25% of figure's width & vertically offset (from bottom) 50%. Box fits around text. Default Height is 10% of height x 10% width
% an.FontSize=14
% 
% 
% figure(5) % Total number of land steps versus time
% 
% yyaxis right
% totalonstepsplot=plot(x,mean(TotalOnSteps,1), 'c')
% totalonstepsplot.LineWidth=3
% totalonstepsplot.DisplayName='Average Land Steps'
% 
% hold on
% 
% yyaxis left
% totalontimeplot=plot(x,mean(TotalOnTime,1), 'c:')
% totalontimeplot.LineWidth=3
% totalontimeplot.DisplayName='Total Time Spent Landing'
% 
% xlabel('Length (in Monomers) of Filament')
% ylabel('Time (Left) and Number of Steps (Right)')
% title('Number of Landing Steps and Time Spent Landing Versus Length', 'FontSize',14)
% set(gca, 'fontsize',20)
% 
% legend show
% 
% an=annotation('textbox', [0.25, 0.5, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on') %text box horizontally offset (from left) 25% of figure's width & vertically offset (from bottom) 50%. Box fits around text. Default Height is 10% of height x 10% width
% an.FontSize=14
% 
% 
