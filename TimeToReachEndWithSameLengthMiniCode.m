
NumberOfRuns=100
StartingPositions=[10 20 30 40 50 60 70 80 90]
LengthOfFilament= 100
DidMotorReachEnd=0
TimeToEndMatrix=zeros(size(StartingPositions, 2), NumberOfRuns)


for j=(1:size(StartingPositions, 2))

    Position=StartingPositions(j);
    
    MotorPosition=Position;
    
for i=(1:NumberOfRuns)
    
    T=zeros(NumberOfRuns)
        
while DidMotorReachEnd<1
            
      
            
            
%%%%Probabilities%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Motor Walks
   q=rand
    
    kWalkTotal=1
    
 
    
        if q<.5
            MotorPosition=MotorPosition+1;
            A=1
        else
            MotorPosition=MotorPosition-1;
            A=2
        end

        MotorPosition
            
        if MotorPosition==LengthOfFilament
            DidMotorReachEnd=1;
        end       
         if MotorPosition==1
            DidMotorReachEnd=1;
         end
        
         DidMotorReachEnd
            
          DT(i)=exprnd(1/kWalkTotal);

          T(i+1)=T(i)+DT(i);  
            
end
        
TimeToEndMatrix(j,i)=T(i)        
        
end
    
    
end