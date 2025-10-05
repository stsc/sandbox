#!/usr/bin/perl
# In use with lighttpd's server.errorfile-prefix option

use strict;
use warnings;

my @errors = (
    [ '401', 'Unauthorized access'   ],
    [ '403', 'Access forbidden'      ],
    [ '404', 'Document not found'    ],
    [ '500', 'Internal Server Error' ],
);

foreach my $error (@errors) {
    my $code = $error->[0];
    unlink "$code.html";
}

my $template = do { local $/; <DATA> };

foreach my $error (@errors) {
    my ($code, $message) = @$error;
    my $output = do {
        local $_ = $template;
        s/\$TITLE/$message ($code)/;
        s/\$MESSAGE/$message!/;
        $_
    };
    my $output_filename = "$code.html";
    open(my $fh, '>', $output_filename) or die "Cannot open $output_filename for writing: $!\n";
    print {$fh} $output;
    close($fh);
}

__DATA__
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
       "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
    <link rel="shortcut icon" type="image/x-icon" href="/~sts/favicon.ico">
    <title>$TITLE</title>
  </head>
  <body bgcolor="#ffffff" style="font-family:Arial, Helvetica, sans-serif">
    <h1>$MESSAGE</h1>
    <a href="/~sts">Back to main page</a>
  </body>
</html>
