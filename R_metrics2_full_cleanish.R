#######LIBRARIES#######
#.libPaths('O:/_Rpackages')
# install.packages('igraph', repos='https://cloud.r-project.org/')
# install.packages('network', repos='https://cloud.r-project.org/')
# install.packages('sna', repos='https://cloud.r-project.org/')
# install.packages('dplyr', repos='https://cloud.r-project.org/')
# install.packages('tibble', repos='https://cloud.r-project.org/')
# install.packages('tidyr', repos='https://cloud.r-project.org/')
# install.packages('tidyverse', repos='https://cloud.r-project.org/')
# install.packages('haven', repos='https://cloud.r-project.org/')
# install.packages('foreign', repos='https://cloud.r-project.org/')

library(igraph)
library(network)
library(sna)
library(dplyr)
library(tibble)
library(tidyr)
library(tidyverse)
library(haven)
# input Stata file
library(foreign)


suffix<-"_3_6_weekly"
path<-"/project/6068332/dennisma/Data/processed_stata/weekly_3_6/"
      
######FUNCTIONS#######
#ok so produce 1000 random graphs w/ degree dist input, then use mean coeff as null model:
get_random_rc <-function(degree_distribution, min_deg) 
{
  # get the degree centrality totals for each addr:
  rg.el<-get.edgelist(rg)
  colnames(rg.el)<-c("addr1","addr2")
  rg.df<-as.data.frame(rg.el)
  
  rg1<-rg.df %>%
    group_by(addr1) %>%
    summarise(Count1=n())
  
  rg2<-rg.df %>%
    group_by(addr2) %>%
    summarise(Count2=n())
  
  rg2<-rename(rg2, addr1=addr2)
  #get to and from totals
  rg.sums<-merge(rg1, rg2, by='addr1', all=TRUE)
  rg.sums[is.na(rg.sums)]<-0
  #combine
  rg.sums$total<-rg.sums$Count1+rg.sums$Count2
  #drop counts
  rg.sums<-select(rg.sums,-c(Count1 , Count2))
  rg.sums<-rename(rg.sums, total1=total)
  rg.df<-merge(rg.df,rg.sums, by='addr1', all=TRUE)
  #now merge the to addresses
  rg.sums<-rename(rg.sums, total2=total1)
  rg.sums<-rename(rg.sums, addr2=addr1)
  rg.df<-merge(rg.df,rg.sums, by='addr2', all=TRUE)
  return(subset(rg.df,total1>=min_deg & total2>=min_deg)) #this returns an edgelist w/ centralities for only the RC (subnetwork exceeding min_deg)
}

#returns a vector of rich club coeffs for a given degree_distribution and min_deg across runs
get_null_rc <-function(degree_distribution, min_deg, runs=1000) {
  sample_rc<-c() #fill this w/ the graphs
  set.seed(123)
  for (i in 1:runs) {
    v1_random_net<-get_random_rc(degree_distribution, min_deg)
    sample_rc<-c(sample_rc,get_rccoeff(v1_random_net))
  }
  return(as.numeric(sample_rc))
}

#returns the rich club coeff for a given input network (edgelist)
get_rccoeff<-function(network) {
  #get number of edges=E
  E<-count(network)
  #get number of nodes=N
  N<-length(unique(c(network$addr1,network$addr2)  ))
  #return rich club coeff=2(E)/(N)(N-1)
  rccoeff<-2*E/(N*(N-1))
  return (as.numeric(rccoeff[[1]]))
}
###################################
#actual full list:
address_list<-list("dac17f958d2ee523a2206206994597c13d831ec7",	"174bfa6600bf90c885c7c01c7031389ed1461ab9",	"0e3a2a1f2146d86a604adc220b4967a898d7fe07",	"03cb0021808442ad5efb61197966aef72a1def96",	"06012c8cf97bead5deae237070f9587f8e7a266d",	"c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2",	"89d24a6b4ccb1b6faa2625fe562bdd9a23260359",	"f230b790e05390fc8295f4d3f60332c93bed42e2",	"86fa049857e0209aa7d9e616f7eb3b3b78ecfdb0",	"1f573d6fb3f13d689ff844b4ce37794d79a7ff1c",	"c0829421c1d260bd3cb3e0f06cfe2d52db2ce315",	"58959e0c71080434f237bd42d07cd84b74cef438",	"744d70fdbe2ba4cf95131626614a1763df805b9e",	"d5dc8921a5c58fb0eba6db6b40eab40283dc3c01",	"7a271d1df2c3f2fef734611c6c7ee6b9b8439204",	"f3e014fe81267870624132ef3a646b8e83853a96",	"1f28f618a2b4e1882ed062db9a4f6298f125e4b8",	"93e682107d1e9defb0b5ee701c71707a4b2e46bc",	"82070415fee803f94ce5617be1878503e58f0a6a",	"c0f1728d9513efc316d0e93a0758c992f88b0809",	"dd974d5c2e2928dea5f71b9825b8b646686bd200",	"8c9b261faef3b3c2e64ab5e58e04615f8c788099",	"3f5fa71ea48ae374faae502afa2e27715484c3b7",	"4a8f44be523580a11cdb20e2c7c470adf44ec9bb",	"8e1b448ec7adfc7fa35fc2e885678bd323176e34",	"5edc1a266e8b2c5e8086d373725df0690af7e3ea",	"818fc6c2ec5986bc6e2cbf00939d90556ab12ce5",	"c45ba8f03ac63e4505ac5eed4985fb4e5e94383a",	"4dc3643dbc642b72c158e7f3d2ff232df61cb6ce",	"a37d94e80eab7a5bcb6d2e76b7666e341e4b58f6",	"ef68e7c694f40c8202821edf525de3782458639f",	"bd13e53255ef917da7557db1b7d2d5c38a2efe24",	"05f4a42e251f2d52b8ed15e9fedaacfcef1fad27",	"45555629aabfea138ead1c1e5f2ac3cce2add830",	"aafd35ddb9189995937a2862e8ff17519f5aae78",	"8e870d67f660d95d5be530380d0ec0bd388289e1",	"d7cc16500d0b0ac3d0ba156a584865a43b0b0050",	"6a750d255416483bec1a31ca7050c6dac4263b57",	"595832f8fc6bf59c85c527fec3740a1b7a361269",	"d77bcd9cf4212a41defbcd2e2ff0f50fea2be643",	"bc2faad1ec407571249b0e874a9abd840111389b",	"4672bad527107471cb5067a887f4656d585a8a31",	"419d0d8bdd9af5e606ae2232ed285aff190e711b",	"bddab785b306bcd9fb056da189615cc8ece1d823",	"8971f9fd7196e5cee2c1032b50f656855af7dd26",	"e36df5bb57e80629cfc28a31e5f794071c085eca",	"41e5560054824ea6b0732e656e3ad64e20e94e45",	"0f5d2fb29fb7d3cfee444a200298f468908cc942",	"bf2179859fc6d5bee9bf9158632dc51678a4100e",	"d850942ef8811f2a866692a623011bde52a462c1",	"58a4884182d9e835597f405e5f258290e46ae7c2",	"fc87d4f82fc5fe80a2d1692ffee872b2517c34c7",	"5b8174e20996ec743f01d3b55a35dd376429c596",	"9992ec3cf6a55b00978cddf2b27bc6882d88d1ec",	"e7d7b37e72510309db27c460378f957b1b04bd5d",	"151bc71a40c56c7cb3317d86996fd0b4ff9bd907",	"e6b75a1960f91bfa7010dec8543685ead67f8cff",	"6f259637dcd74c767781e37bc6133cd6a68aa161",	"92e52a1a235d9a103d970901066ce910aacefd37",	"816051e2203ca534c4336d8d6df71987fa3ae0bd",	"77fe30b2cf39245267c0a5084b66a560f1cf9e1f",	"d97e471695f73d8186deabc1ab5b8765e667cd96",	"af47ebbd460f21c2b3262726572ca8812d7143b0",	"69b148395ce0015c13e36bffbad63f49ef874e03",	"457476bc97adef10aba63fcadaefe503553fa0d2",	"80fb784b7ed66730e8b1dbd9820afd29931aab03",	"ab4e1802c61e12fd7b10a69a226f5d727c76a8aa",	"1530df3e1c69501d4ecb7e58eb045b90de158873",	"3f17dd476faf0a4855572f0b6ed5115d9bba22ad",	"3616fd03f11e22942e4fc01cdd0f1ca7cc7bb93d",	"c5bbae50781be1669306b9e001eff57a2957b09d",	"02b3c88b805f1c6982e38ea1d40a1d83f159c3d4",	"bf5f8bfcee9502a30018d91c63eca66980e6e9bb",	"03df4c372a29376d2c8df33a1b5f001cd8d68b0e",	"b5a5f22694352c15b00323844ad545abb2b11028",	"3597bfd533a99c9aa083587b074434e61eb0a258",	"516e5436bafdc11083654de7bb9b95382d08d5de",	"04abeda201850ac0124161f037efd70c74ddc74c",	"bd65f6f9f9f87af2a677709e132debc3f242671d",	"b97048628db6b661d4c2aa833e95dbe1a905b280",	"f53ad2c6851052a81b42133467480961b2321c09",	"f3586684107ce0859c44aa2b2e0fb8cd8731a15a",	"fa1a856cfa3409cfa145fa4e20eb270df3eb21ab",	"1234567461d3f8db7496581774bd869c83d51c93",	"f5b0a3efb8e8e4c201e2a935f110eaaf3ffecb8d",	"275b69aa7c8c1d648a0557656bce1c286e69a29d",	"351d5ea36941861d0c03fdfb24a8c2cb106e068b",	"3c7b464376db7c9927930cf50eefdea2eff3a66a",	"d0929d411954c47438dc1d871dd6081f5c5e149c",	"08ceed1e8db59acbb687a5752f0a7db815cfda5e",	"5ca9a71b1d01849c0a95490cc00559717fcf0d1d",	"8912358d977e123b51ecad1ffa0cc4a7e32ff774",	"d0a4b8946cb52f0661273bfbc6fd0e0c75fc6433",	"6c6ee5e31d828de241282b9606c8e98ea48526e2",	"d4de05944572d142fbf70f3f010891a35ac15188",	"cba8162778e6a3eba60e1cf7c012b327340bd05d",	"fb5a551374b656c6e39787b1d3a03feab7f3a98e",	"53066cddbc0099eb6c96785d9b3df2aaeede5da3",	"bcc394d45c3613530a83cae62c716dc23b7f2152",	"8f8221afbb33998d8584a2b05749ba73c37a938a",	"42f1d3380cc1526eb182343dc3bdd970ce664322",	"f8c595d070d104377f58715ce2e6c93e49a87f3c",	"6b175474e89094c44da98b954eedeac495271d0f",	"47a16e51bcc89c0015622fe83eb482a4522f6c5c",	"9eec65e5b998db6845321baa915ec3338b1a469b",	"076641af1b8f06b7f8c92587156143c109002cbe",	"c12d1c73ee7dc3615ba4e37e4abfdbddfa38907e",	"49592d97be49033615a7fbc02c6853e4c58eb9bc",	"3cc83c2400e00a54fa1e588d62bc28bf15d5def5",	"809826cceab68c387726af962713b64cb5cb3cca",	"d2299b3098cf5e13144caebfdad61ebe505233dc",	"9b4e2b4b13d125238aa0480dd42b4f6fc71b37cc",	"a720911a58d948fc9328560aecfc51e907404fc4",	"419c4db4b9e25d6db2ad9691ccb832c8d9fda05e",	"f1ca9cb74685755965c7458528a36934df52a3ef",	"d4fa1460f537bb9085d22c7bccb5dd450ef28e3a",	"b6ed7644c69416d67b522e20bc294a9a9b405b31",	"d7732e3783b0047aa251928960063f863ad022d8",	"8853b05833029e3cf8d3cbb592f9784fa43d2a79",	"b63b606ac810a52cca15e44bb630fd42d8d1d83d",	"b68042de5b3da08a80c20d29aefab999d0848385",	"f6276830c265a779a2225b9d2fcbab790cbeb92b",	"1985365e9f78359a9b6ad760e32412f4a445e862",	"f226e38c3007b3d974fc79bcf5a77750035436ee",	"b62132e35a6c13ee1ee0f84dc5d40bad8d815206",	"d73be539d6b2076bab83ca6ba62dfe189abc6bbe",	"e62e6e6c3b808faad3a54b226379466544d76ea4",	"6ef77d991eb5306e9f235abc0cc65925da398ad0",	"007ac2f589eb9d4fe1cea9f46b5f4f52dab73dd4",	"e6bc60a00b81c7f3cbc8f4ef3b0a6805b6851753",	"2b7922fdf76fb3466902c7b702a20ea6a450a0a0",	"d48b633045af65ff636f3c6edd744748351e020d",	"3b8a1122316a9520b4ffe867f56a130c1524a64f",	"b31c219959e06f9afbeb36b388a4bad13e802725",	"2b591e99afe9f32eaa6214f7b7629768c40eeb39",	"8bcb64bfda77905398b67af0af084c744e777a20",	"e477292f1b3268687a29376116b0ed27a9c76170",	"b7cb1c96db6b22b0d3d9536e0108d062bd488f74",	"1519aff03b3e23722511d2576c769a77baf09580", "8fdcc30eda7e94f1c12ce0280df6cd531e8365c5",	"dc17e8a84fee8b52e4de7a85160f8cdbb3bb2494",	"8e766f57f7d16ca50b4a0b90b88f6468a09b0439",	"d26114cd6ee289accf82350c8d8487fedb8a0c07",	"74fd51a98a4a1ecbef8cc43be801cce630e260bd",	"514910771af9ca656af840dff83e8264ecf986ca",	"9e15f8ad98e95033c1d4798458cec34a4b5972b0",	"0d8775f648430679a709e98d2b0cb6250d2887ef",	"21ab6c9fac80c59d401b37cb43f81ea9dde7fe34",	"0e50e6d6bb434938d8fe670a2d7a14cd128eb50f",	"b64ef51c888972c908cfacf59b47c1afbc0ab8ac",	"7b2f9706cd8473b4f5b7758b0171a9933fc6c4d6",	"a15c7ebe1f07caf6bff097d8a589fb8ac49ae5b3",	"c5d105e63711398af9bbff092d4b6769c82f793d",	"a5b46ff9a887180c8fb2d97146398ddfc5fef1cd",	"b64ffdca47d6c3895608c4e05faba6e617b3a031",	"a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48",	"ac08809df1048b82959d6251fbc9538920bed1fa",	"519475b31653e46d20cd09f9fdcf3b12bdacb4f5",	"bc4162d53f945266684f4e5e48d545f206bc1ca5",	"52903256dd18d85c2dc4a6c999907c9793ea61e3",	"06a6a7af298129e3a2ab396c9c06f91d3c54aba8",	"573aaaa81154cd24e96f0cb97fd86110b8f6767f",	"e41d2489571d322189246dafa5ebde1f4699f498",	"b8c77482e45f1f44de1745f52c74426c631bdd52",	"62b9f8741bf53a6986a5411c0557c30f6f11f3af",	"27695e09149adc738a978e9a678f99e4c39e9eb9",	"7c5cb1220bd293ff9cf903915732e51a71292038",	"ab95e915c123fded5bdfb6325e35ef5515f1ea69",	"0d152b9ee87ebae179f64c067a966dd716c50742",	"1f0480a66883de97d2b054929252aae8f664c15c",	"c9c4d9ec2b44b241361707679d3db0876ac10ca6",	"d3ebdaea9aeac98de723f640bce4aa07e2e44192",	"8a88f04e0c905054d2f33b26bb3a46d7091a039a",	"e1ac9eb7cddabfd9e5ca49c23bd521afcdf8be49",	"931abd3732f7eada74190c8f89b46f8ba7103d54",	"3495ffcee09012ab7d827abf3e3b3ae428a38443",	"cafe27178308351a12fffffdeb161d9d730da082",	"f629cbd94d3791c9250152bd8dfbdf380e2a3b9c",	"5da8d37485b4374fc338fc1f1ea31d07eb7bedd3",	"2e65e12b5f0fd1d58738c6f38da7d57f5f183d1c",	"5e7ebea68ab05198f771d77a875480314f1d0aae",	"e530441f4f73bdb6dc2fa5af7c3fc5fd551ec838",	"9f8f72aa9304c8b593d555f12ef6589cc3a579a2",	"686b30a80826340a59afa564c2a01b79128eb7dd",	"212d95fccdf0366343350f486bda1ceafc0c2d63",	"4092678e4e78230f46a1534c0fbc8fa39780892b",	"c4131c1893576e078a0b637b653f3e6a18e137ac",	"0e69d0a2bbb30abcb7e5cfea0e4fde19c00a8d47",	"a68920f6d3c996ac3c232e4e93914e9d76150735",	"0cf0ee63788a0849fe5297f3407f701e122cc023",	"68e54af74b22acaccffa04ccaad13be16ed14eac",	"9e9801bace260f58407c15e6e515c45918756e0f",	"ba7435a4b4c747e0101780073eeda872a69bdcd4")

for(addr_name in address_list){

  print(addr_name)
  #import data
  dta_name<-paste(path,addr_name,suffix,".dta", sep="")
  df_full <- read_dta(dta_name)
  #keep only from to and tp; then rename from and to to addr1 and addr2
  names(df_full)[names(df_full) == 'from'] <- 'addr1'
  names(df_full)[names(df_full) == 'to'] <- 'addr2'
  
  #prepare the network-tp level dataframe 
  final<-as.data.frame(unique(df_full$tp))
  names(final)[names(final) == 'unique(df_full$tp)']  <- 'tp'
  final<-final%>%
    add_column(address=addr_name) #replace this w/ the address: passed as argument when executing this script
 
 
  #now loop through the distinct TPs, and populate these values for each TP
tplist<-unique(df_full$tp)

  for (i in tplist) {
    #cycle through each TP to get the graph for that particular TP
    df<-df_full[df_full$tp==i,]
    temp<-graph_from_edgelist(as.matrix(df[,c(1,2)]), directed=FALSE)
    size<-gorder(temp)
    #when edgelist with only two columns is required 
    addonly<-c("addr1","addr2")
    df_ao<-df[addonly]

    
    ##CLUSTERING COEFFICIENT##
    clustering<-transitivity(graph_from_edgelist(as.matrix(df_ao), directed=FALSE), type = "average")
    transitivity<-transitivity(graph_from_edgelist(as.matrix(df_ao), directed=FALSE))
    ##CENTRALIZATION COEFFICIENT##
    #centralization<-centralization(df_ao, degree) #seems high? but read up on it, it's actually OK / no it's not, becuase it becomes highly correlated w/ size since it's not normalized... use a normalized version:
    centralization<-centralization.degree(graph_from_edgelist(as.matrix(df_ao)))$centralization  #this version is normalized
    
    ##for the Rich club coeff, we need to obtain the degree distribution to form a subgraph of rich nodes only
    #now to add degree distribution of each node in the edgelist
    table(df$addr1) 
    summary_data1<-df %>%
       group_by(addr1) %>%
       summarise(Count=n())
    
    summary_data2<-df %>%
      group_by(addr2) %>%
      summarise(Count=n())
    

    names(summary_data2)[names(summary_data2) == 'addr2'] <- 'addr1'
    names(summary_data2)[names(summary_data2) == 'Count'] <- 'Count2'

    sums<-merge(summary_data1, summary_data2, by='addr1', all=TRUE)
    sums[is.na(sums)]<-0
    #sums
    sums$total<-sums$Count+sums$Count2

    sums<-select(sums,-c(Count , Count2))
 
    # now to only keep the high centrality nodes.
    # one way to do it is to merge in the centrality scores and delete the ones that don't make the cut
    # that'll give you your high centrality subset...
    # then, calculate rich club coeff.

    names(sums)[names(sums) == 'total'] <- 'total1'

    merged<-merge(df, sums, by='addr1', all=TRUE)
    #merged
    names(sums)[names(sums) == 'addr1'] <- 'addr2'
    names(sums)[names(sums) == 'total1'] <- 'total2'
    
    merged<-merge(merged, sums, by='addr2', all=TRUE)
    #merged
    long<-gather(merged, addr, deg, total1, total2)
    long$address[long$addr=="total1"]<-long$addr1
    long$address[long$addr=="total2"]<-long$addr2
    long<-subset(long, select=c("address","deg"))
    long<-long %>% drop_na()
    long<-long[!duplicated(long),]
  
    #determine cutoff 
    minimum<-mean(long$deg)
  
    #     #also be sure to specify as an undirected edgelist...
        gr.gr<-graph_from_edgelist(as.matrix(df_ao), directed=FALSE)
        #something happens here where the degree function produces a bunch of 0 entries...i think ti's because the degree fucntion expects numerically ordered IDs ...so if you have 1 2 3 10; it'll fill in 4-9 as isolates
        #need to renumber the IDs so that we don't end up with isolates...or figure out some similar solution
        #might need to determine if there is a valid degree distribution... otherwise next function won't work?

        Isolated = which(igraph::degree(gr.gr)==0)
        gr.gr=gr.gr-Isolated
        degree_dist<-igraph::degree(gr.gr) #get the degree distribution
    #min_rob
    richonly<-subset(merged,total1>=minimum & total2>=minimum)

     rc_coeff<-get_rccoeff(richonly) #the un-normalized RC Coeff
 #this won't accept 0 as a degree value...which makes sense given the data; so figure out why there is 0 in the data
     rc_null<-get_null_rc(degree_dist, minimum) #will need to convert from edgelist first for actual run
     
    #approach #1: use this as the null metric
   mean_rc_null<-mean(rc_null)

 #need to be able to catch instances where mean_rc_null is NULL
  if (is.na(mean_rc_null)) {
    print("Null RC Coeff is NA")
    rc_coeff_norm=rc_coeff
    rc_coeff_pctl=1 #max it out I guess?
      
  }
  else{
    rc_coeff_pctl=100*ecdf(rc_null)(rc_coeff) #percentile
    rc_coeff_norm=rc_coeff/mean_rc_null #now divide to get the normalized coefficient
    #approach #2: detect where in the distribution the rccoeff lies
    #RC coefficients
    final$rc_raw[final$tp==i]<-rc_coeff
    final$rc_cut[final$tp==i]<-minimum
    final$rc_pctl[final$tp==i]<-rc_coeff_pctl
    final$rc_denom[final$tp==i]<-mean_rc_null
    final$rc_norm[final$tp==i]<-rc_coeff_norm
  }

    #WRITE VALUES
    final$clustering[final$tp==i]<-clustering
    final$transitivity[final$tp==i]<-transitivity
    final$centralization[final$tp==i]<-centralization
    final$size[final$tp==i]<-size #forgot this last time...adding now
           final$rc_raw[final$tp==i]<-rc_coeff
           final$rc_cut[final$tp==i]<-minimum
  #now do this for each time period.
  }

  write.table(final, file = paste(path, addr_name, suffix,"_rawRC.csv", sep=""), quote=FALSE, row.names=FALSE)
  print(paste("completed", path, addr_name))
}
#save out the the correct folder and with the same naming convention for merging.
#merge with the connectance and cross functionality measures that get calculated in Stata
#warnings()