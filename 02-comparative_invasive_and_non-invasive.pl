#!usr/bin/perl -w
use strict;

#usage: perl $0 01-statistic_common_ex_inv.txt 02-statistic_common_ex_non.txt
open IN1,"<",$ARGV[0] || die "can't open IN1:$!";
open IN2,"<",$ARGV[1] || die "can't open IN2:$!";
open OUT,">","result.txt";
my ($tf_id_inv,$tf_id_non,@tf_id_inv,@tf_id_non,%num_inv,%num_non,%species_inv,%species_non,$time);

while (<IN1>) {
	chomp();
	my @array = split(/\t/,$_);
	$tf_id_inv = $array[0];
	$num_inv{$tf_id_inv} = $array[1];
	$species_inv{$tf_id_inv} = $array[2];
	push(@tf_id_inv,$tf_id_inv);
	# body...
}

while (<IN2>) {
	chomp();
	my @array = split(/\t/,$_);
	$tf_id_non = $array[0];
	$num_non{$tf_id_non} = $array[1];
	$species_non{$tf_id_non} = $array[2];
	push(@tf_id_non,$tf_id_non);
	# body...
}
print OUT "inv_tf_id\tnon_tf_id\tnum_inv\tnum_non\ttime\tspecies_inv\tspecies_non\n";
foreach $tf_id_inv(sort keys %num_non){
	for (my $i = 0; $i <=$#tf_id_non; $i++) {
		if ($tf_id_inv eq $tf_id_non[$i]) {
			$time = $num_inv{$tf_id_inv}/$num_non{$tf_id_non[$i]};
			print OUT "$tf_id_inv\t$tf_id_non[$i]\t$num_inv{$tf_id_inv}\t$num_non{$tf_id_non[$i]}\t$time\t$species_inv{$tf_id_inv}\t$species_non{$tf_id_non[$i]}\n";
			# body...
		}
		# body...
	}
}

my %hash_inv = map{$_=>1} @tf_id_inv;  
my %hash_non = map{$_=>1} @tf_id_non;  
my %merge_all = map {$_ => 1} @tf_id_inv,@tf_id_non;

my @tf_inv_only = grep {!$hash_non{$_}} @tf_id_inv;  
my @tf_non_only = grep {!$hash_inv{$_}} @tf_id_non;  
my @common = grep {$hash_inv{$_}} @tf_id_non;  
my @merge = keys (%merge_all);

my $no = "NA";
#print OUT "A only :\n";   
for (my $i = 0; $i <=$#tf_inv_only; $i++) {
	print OUT "$tf_inv_only[$i]\t$no\t$num_inv{$tf_inv_only[$i]}\t$no\t$no\t$species_inv{$tf_inv_only[$i]}\t$no\n";
}

for (my $i = 0; $i <=$#tf_non_only; $i++) {
	print OUT "$no\t$tf_non_only[$i]\t$no\t$num_non{$tf_non_only[$i]}\t$no\t$no\t$species_non{$tf_non_only[$i]}\n";
}