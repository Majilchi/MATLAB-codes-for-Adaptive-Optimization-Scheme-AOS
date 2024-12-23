%--------------------------------------------------------------------------------------------------------------------------
% Adaptive optimization scheme (AOS)
% Majid Ilchi Ghazaan, Amirmohammad Salmani Oshnari, Amirhossein Salmani Oshnari,
% A novel adaptive optimization scheme for advancing metaheuristics and global optimization,
% Swarm and Evolutionary Computation, Volume 91, 2024, 101779, ISSN 2210-6502,
% DOI: https://doi.org/10.1016/j.swevo.2024.101779.
% (https://www.sciencedirect.com/science/article/pii/S2210650224003171)
% Programmed by: Amirmohammad Salmani Oshnari & Amirhossein Salmani Oshnari
% e-mail: ilchi@iust.ac.ir, amirmohammad78.salmani@gmail.com & salmaniamirhossein78@gmail.com
% Updated 21 Nov. 2024.
%--------------------------------------------------------------------------------------------------------------------------

function [Positions, bestX, XX, pX, fMin, pFit, FE, Beta_k]=AOS(alpha, UB, LB,...
    Positions, fitness, FunIndex, dim, Particles_no, bestX, XX, pX,...
    fMin, pFit, n, m, beta, Beta_k, FE, FEmax)
Fit(:,1) = fitness;
Fit(:,2) = 1:Particles_no;
Fit=sortrows(Fit,1);
for j=1:Particles_no
%____________________Levy_______________________%
  if(rand<0.1-0.1*FE/FEmax)
  X_Levy(1,:)=bestX.*Levy(n,m,beta)*alpha;
        X_Levy= Flag(UB, LB, X_Levy, dim);
        if (BenFunctions(X_Levy(1,:),FunIndex,size(X_Levy,2))<fitness(Fit(j,2)))
        Positions(Fit(j,2),:)=X_Levy(1,:);
        fitness(Fit(j,2))=BenFunctions((X_Levy(1,:)),FunIndex,dim);
        Fit(j,1) = fitness(Fit(j,2));
        end   
             FE = FE + 1;
        XX=pX;
        if ( fitness( Fit(j,2) ) < pFit( j ) )
            pFit( j ) = fitness( Fit(j,2) );
            pX( j, : ) = Positions( Fit(j,2), : );
        end
        
        if( pFit( j ) < fMin )
           % fMin= pFit( i );
           fMin= pFit( j );
            bestX = pX( j, : );
          %  a(i)=fMin;
        end
             if FE >= FEmax
                 break
             end
  end
        XX=pX;
        if ( fitness( Fit(j,2) ) < pFit( j ) )
            pFit( j ) = fitness( Fit(j,2) );
            pX( j, : ) = Positions( Fit(j,2), : );
        end
        
        if( pFit( j ) < fMin )
           % fMin= pFit( i );
           fMin= pFit( j );
            bestX = pX( j, : );
          %  a(i)=fMin;
        end
             if FE >= FEmax
                 break
             end
end
Fit=sortrows(Fit,1);

%__________________________CLS+OBL__________________________%
           [X_CLS, Beta_k]= CLS(Beta_k, FE, FEmax, UB, LB, bestX);
           X_OBL= OBL(UB, LB, X_CLS);
           X_CLS= Flag(UB, LB, X_CLS, dim);
           X_OBL= Flag(UB, LB, X_OBL, dim);
           F_CLS=BenFunctions((X_CLS(1,:)),FunIndex,dim);
           F_OBL=BenFunctions((X_OBL(1,:)),FunIndex,dim);
           FE=FE+2;
           if(F_OBL<F_CLS && F_OBL<fMin)
               fMin=F_OBL;
               bestX=X_OBL;
           elseif (F_CLS<F_OBL && F_CLS<fMin)
               fMin=F_CLS;
               bestX=X_CLS;
           end
           for i=1:Particles_no
               fitness(Fit(i,2))=Fit(i,1);
           end
end