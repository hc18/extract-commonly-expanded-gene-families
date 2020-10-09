#!usr/bin/perl -w
use strict;

sub Usage(){
	print "
	Usage: 
		perl get_common.pl
	Description:
		This script is used to get the common expansion treefam gene families of all invasive species, and statistic the species numbers of each treefam id.
		Firstly, you must create a folder named 'expansion';
		Secondly, put this script outside the folder;
		And than run this script.

	write by huangcong at 2017.9.27. Please connect huangcong16@163.com
	";
	exit;
}
&Usage if $#ARGV >=0;


my $dirname = '01-invasive';
opendir DIR,$dirname or die "can't open $dirname:$!";
my $species;
while (my $file = readdir DIR) {
	next if $file =~ /^\./;
	if ($file =~ /(\w+)\.Expansion\.txt/) {
		$species = $1;
	}

	open IN1,"<","$dirname/$file" || die "can't open $file :$!";
	open OUT1,">","$dirname/$species.ex_tf_id.txt";
	my $tf_id_1;
	while (<IN1>) {
		chomp();
		my @array_temp = split (/\t/,$_);
		$tf_id_1 = $array_temp[0];
		print OUT1 "$species\t$tf_id_1\n";
	}
	close IN1;
	close OUT1;

   	system "cat $dirname/$species.ex_tf_id.txt >> $dirname/all_ex_tf_id.txt";

	open IN2,"<","$dirname/all_ex_tf_id.txt" || die "can't open $file: $!";
	open OUT2,">","$dirname/statistic_common_ex.txt";
	my $tf_id;
	my @tf_id;
	my @specie_name;
	my %specie_tf;
	my %count;
	while (<IN2>) {
		chomp();
		my @array = split(/\t/,$_);
		$tf_id = $array[1];
		$specie_tf{$tf_id} .= "$array[0];";
		push (@tf_id,$tf_id);
	}

	foreach $tf_id (@tf_id){
		$count{$tf_id}++;
	}

	foreach $tf_id (sort { $count{$b} <=> $count{$a} } keys %count){
		@specie_name = split(/\;/,$specie_tf{$tf_id});
			print OUT2 "$tf_id\t$count{$tf_id}\t@specie_name\n";
	}

	close IN2;
	close OUT2;	
}

close DIR;
