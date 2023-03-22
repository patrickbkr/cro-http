use Cro::HTTP::Client;

my $url = "https://localhost/foo.txt";

my Cro::HTTP::Client $cro .= new:
#    :http<1.1>,
    :http<2>,
    tls => { ssl-key-log-file => "/home/patrickb/repos/RakudoCIBot/ssl-key-log-file", },
    ca => { :insecure };

my $c;
loop {
    my $res = await $cro.get: $url;
    my $body = await $res.body-text;
    last if $c++ > 10;
    print "0";
}
