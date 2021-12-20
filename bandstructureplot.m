function bandstructureplot(Npaths,Ef)
%function to plot bandstructure and Fermi Level(Ef) for #Npaths high symmetry paths

% (kx,ky,kz)coordinates
bandkpoints=load ('bandkpoints.txt');
% energies as rows=kpoints, columns=bands
bandenergies=load ('bandenergies.txt');

sz1=size(bandkpoints);
sz2=size(bandenergies);

%number of bands
Nband=sz2(2);

%number of kpoints
Npoints=sz1(1);

%size of segments
seg=Npoints/Npaths;

kpoints=ones(Npaths*2,3);
%high symmetry directions
d=ones(Npaths,3);
cosi=ones(Npaths,3);

%define directions
for i=1:Npaths

   kpoints((i-1)*2+1,:)=bandkpoints((i-1)*seg+1,:);
   kpoints((i-1)*2+2,:)=bandkpoints(i*seg,:);
   d(i,:)= kpoints((i-1)*2+2,:)-kpoints((i-1)*2+1,:);
   
   for dir=1:3
   cosi(i,dir)=d(i,dir)./norm(d(i,:));
   end
   
end

%plot bandstructure
for l=1:Npaths
for m=1:Nband
    
    subplot(1,Npaths,l);
    plot(bandkpoints(seg*(l-1)+1:seg*l,:)*(cosi(l,:)).',bandenergies(seg*(l-1)+1:seg*l,m),'-','Linewidth', 2);
    %define path after plot
    xlabel(sprintf('path %d', l));
    set(gca,'xtick',[])
    
    if l>1
       set(gca,'ytick',[]) 
    else 
        ylabel('Energy (eV)');
    end
   
    plot(bandkpoints(seg*(l-1)+1:seg*l,:)*(cosi(l,:)).',Ef*ones(1,seg),'k--','Linewidth',2);
    hold on
    ylim([min(min(bandenergies)) max(max(bandenergies))]);
    
end

end
