package Term::ExtendedColor;

$VERSION = '0.10';

require Exporter;
@ISA = 'Exporter';
our @EXPORT = qw(uncolor get_colors set_color fg bg clear);

# We need to access the autoreset function by using the fully qualified name.
# If we try to import functions from @EXPORT_OK, the exported functions in
# @EXPORT doesnt get exported at all, for some reason.
# This is 'intended behaviour', according to #perl.
our @EXPORT_OK = qw(autoreset);

#use Data::Dumper::Concise;
use Carp;

our $AUTORESET = 1;

my $fg = "\e[38;";
my $bg = "\e[48;";

my($start, $end);

# There a no way to give these meaningful names.
# The X11 rgb names doesn't match, neither does
# any SVG or HTML colorset.
# Will probably add the colors hex values as another field.
# Will probably remap all of these colors, creating some kind of pattern.


#
#  blue1   => '5;39',
#  blue2   => '5;38',
#  blue3   => '5;33',
#  blue4   => '5;32',
#  blue5   => '5;31',
#  blue6   => '5;27',
#  blue7   => '5;26',
#  blue8   => '5;25',
#  blue9   => '5;21',
#  blue10  => '5;20',
#  blue11  => '5;19',
#  blue12  => '5;18',
#  blue13  => '5;17',
#
#  yellow1 => '5;184',
#  yellow2 => '5;220',
#  yellow3 => '5;190',
#  yellow4 => '5;226',
#  yellow5 => '5;227',
#
#  orange1 => '5;214',
#  orange2 => '5;178',
#  orange3 => '5;172',
#  orange4 => '5;208',
#  orange5 => '5;202',
#  orange6 => '5;166',
#  orange7 => '5;130',
#
#  cerise1 => '5;197',
#  cerise2 => '5;161',
#  cerise3 => '5;125',





my %color_names = (

  reset     => 0,     clear     => 0,     bold      => 1,
  italic    => 3,     underline => 4,     blink     => 5,
  reverse   => 7,

  # Brightest to darkest color

  red1      => '5;196',     # => 'ff0000',
  red2      => '5;160',     # => 'd70000',
  red3      => '5;124',     # => 'af0000',
  red4      => '5;088',     # => '870000',
  red5      => '5;052',     # => '5f0000',

  green1    => '5;156',     # => 'afff87',
  green2    => '5;150',     # => 'afd787',
  green3    => '5;120',     # => '87ff87',
  green4    => '5;114',     # => '87d787',
  green5    => '5;084',     # => '5fff87',
  green6    => '5;078',     # => '5fd787',
  green7    => '5;155',     # => 'afff5f',
  green8    => '5;149',     # => 'afd75f',
  green9    => '5;119',     # => '87ff5f',
  green10   => '5;113',     # => '87d75f',
  green11   => '5;083',     # => '5fff5f',
  green12   => '5;077',     # => '5fd75f',
  green13   => '5;047',     # => '00ff5f',
  green14   => '5;041',     # => '00d75f',
  green15   => '5;118',     # => '87ff00',
  green16   => '5;112',     # => '87d700',
  green17   => '5;082',     # => '5fff00',
  green18   => '5;076',     # => '5fd700',
  green19   => '5;046',     # => '00ff00',
  green20   => '5;040',     # => '00d700',
  green21   => '5;034',     # => '00af00',
  green22   => '5;028',     # => '008700',
  green23   => '5;022',     # => '005f00',
  green24   => '5;107',     # => '87af5f',
  green25   => '5;071',     # => '5faf5f',
  green26   => '5;070',     # => '5faf00',
  green27   => '5;064',     # => '5f8700',
  green28   => '5;065',     # => '5f875f',

  blue1     => '5;075',
  blue2     => '5;074',
  blue3     => '5;073',
  blue4     => '5;039',
  blue5     => '5;038',
  blue6     => '5;037',
  blue7     => '5;033',
  blue8     => '5;032',
  blue9     => '5;031',
  blue10    => '5;027',
  blue11    => '5;026',
  blue12    => '5;025',
  blue13    => '5;021',
  blue14    => '5;020',
  blue15    => '5;019',
  blue16    => '5;018',
  blue17    => '5;017',

  yellow1   => '5;228',
  yellow2   => '5;222',
  yellow3   => '5;192',
  yellow4   => '5;186',
  yellow5   => '5;227',
  yellow6   => '5;221',
  yellow7   => '5;191',
  yellow8   => '5;185',
  yellow9   => '5;226',
  yellow10  => '5;220',
  yellow11  => '5;190',
  yellow12  => '5;184',
  yellow13  => '5;214',
  yellow14  => '5;178',
  yellow15  => '5;208',
  yellow16  => '5;172',
  yellow17  => '5;202',
  yellow18  => '5;166',

  magenta1  => '5;219',
  magenta2  => '5;183',
  magenta3  => '5;218',
  magenta4  => '5;182',
  magenta5  => '5;217',
  magenta6  => '5;181',
  magenta7  => '5;213',
  magenta8  => '5;177',
  magenta9  => '5;212',
  magenta10 => '5;176',
  magenta11 => '5;211',
  magenta12 => '5;175',
  magenta13 => '5;207',
  magenta14 => '5;171',
  magenta15 => '5;206',
  magenta16 => '5;170',
  magenta15 => '5;205',
  magenta16 => '5;169',
  magenta17 => '5;201',
  magenta18 => '5;165',
  magenta19 => '5;200',
  magenta20 => '5;164',
  magenta21 => '5;199',
  magenta22 => '5;163',
  magenta23 => '5;198',
  magenta24 => '5;162',
  magenta25 => '5;197',
  magenta26 => '5;161',

  gray1     => '5;255',
  gray2     => '5;254',
  gray3     => '5;253',
  gray4     => '5;252',
  gray5     => '5;251',
  gray6     => '5;250',
  gray7     => '5;249',
  gray8     => '5;248',
  gray9     => '5;247',
  gray10    => '5;246',
  gray11    => '5;245',
  gray12    => '5;244',
  gray13    => '5;243',
  gray14    => '5;242',
  gray15    => '5;241',
  gray16    => '5;240',
  gray17    => '5;239',
  gray18    => '5;238',
  gray19    => '5;237',
  gray20    => '5;236',
  gray21    => '5;235',
  gray22    => '5;234',
  gray23    => '5;233',
  gray24    => '5;232',

  purple1   => '5;147',
  purple2   => '5;146',
  purple3   => '5;145',
  purple4   => '5;141',
  purple5   => '5;140',
  purple6   => '5;139',
  purple7   => '5;135',
  purple8   => '5;134',
  purple9   => '5;133',
  purple10  => '5;129',
  purple11  => '5;128',
  purple12  => '5;127',
  purple13  => '5;126',
  purple14  => '5;125',
  purple15  => '5;111',
  purple16  => '5;110',
  purple17  => '5;109',
  purple18  => '5;105',
  purple19  => '5;104',
  purple20  => '5;103',
  purple21  => '5;099',
  purple22  => '5;098',
  purple23  => '5;097',
  purple24  => '5;096',
  purple25  => '5;093',
  purple26  => '5;092',
  purple27  => '5;091',
  purple28  => '5;090',

  purple29  => '5;055',
  purple30  => '5;054',
);


our $FG;
our $BG;

sub fg {
  # Call to fg() with zero args resets to defaults
  if(!@_) {
    return("\e[38;0m");
  }
  $FG = ($FG) ? 0 : 1;
  color(@_);
}

sub bg {
  if(!@_) {
    return("\e[38;0m");
  }

  $BG = ($BG) ? 0 : 1;
  color(@_);
}


sub color {
  my $color_str = shift;
  my @data = @_;
  return @data if(!defined($color_str));

  if(!exists($color_names{$color_str})) {
    return($color_str);
  }

  ($start) = ($FG)        ? "\e[38;" : "\e[48;";
  ($end)   = ($AUTORESET) ? "\e[38;0m"  : '';

  if(!(@data)) {
    # Works just like the color() function in Term::ANSIColor
    return("$start$color_names{$color_str}m");
  }

  map{ $_ = "$start$color_names{$color_str}m$_$end" } @data;

  # Restore state
  ($FG, $BG) = (0, 0);
  return(join('', @data)); # FIXME
}

sub uncolor {
  my @data = @_;
  return undef if(!@data);

  for(@data) {
    s/(?:\e|\033)\[[0-9]+(?:;[0-9]+)?(;[0-9]+)m//g;
    s/(?:\e|\033)\[[0-9]+m//g;
  }
  return(@data);
}

sub set_color {
  my $index = shift; # color no 8
  my $color = shift; # ff0000

  if(!defined($index) or ($index eq '')) {
    confess("Need index color (0..255)");
  }
  if(!defined($color) or ($color eq '')) {
  confess("Need color specification in valid hex");
  }

  if(($index < 0) or ($index > 255)) {
    confess("Invalid index: $index. Valid numbers are 0-255\n");
  }
  if($color !~ /^([A-Fa-f0-9]{6}$)/) {
    confess("Invalid hex: $color\n");
  }

  my($r_hex, $g_hex, $b_hex) = $color =~ /(..)(..)(..)/g;
  return("\e]4;$index;rgb:$r_hex/$g_hex/$b_hex\e\\");
}


sub get_colors {
  return(\%color_names);
}

sub clear {
  if(!@_) {
    return("$fg$color_names{clear}m");
  }
}


sub autoreset {
  $AUTORESET = shift;
  ($end) = ($AUTORESET) ? "\e[38;0m" : '';
}

=pod

=head1 NAME

  Term::ExtendedColor - Color screen output using extended escape sequences

=head1 SYNOPSIS

    # fg(), bg(), set_color(), uncolor(), get_colors() imported
    use Term::ExtendedColor;

    ## Foreground colors

    print fg 'green15', "this is bright green foreground\n";
    my $red_text = fg('red2', "this is in red");

    ## Background colors

    print bg('red5', "Default foreground text on dark red background"), "\n";
    my $red_on_green = fg('red3', bg('green12', 'Red text on green background'));
    print "$red_on_green\n";

    ## Fall-thru attributes

    Term::ExtendedColor::autoreset(0);
    my $bold  = fg('bold', 'This is bold');
    my $red   = fg('red2', 'This is red... and bold');
    my $green = bg('green28', 'This is bold red on green background');

    # Make sure to clear all attributes when autoreset turned OFF,
    # or else the users shell will be messed up

    my $clear = clear();
    print "$bold\n";
    print "$red\n";
    print "$green $clear\n";

    ## Non-color attributes

    # Turn on autoreset again
    Term::ExtendedColor::autoreset(1);

    for(qw(italic underline blink reverse bold)) {
      print fg($_, $_), "\n";
    }


    ## Remove all attributes from input data
    my @colored;
    push(@colored, fg('bold', fg('red2', 'Bold and red')));
    push(@colored, fg('green13', fg('italic', 'Green, italic')));

    print "$_\n" for @colored;
    print "$_\n" for uncolor(@colored);


    ## Change some colors.

    # Change the first ANSI color to red
    print set_color(0, 'ff0000');

    # Change the grayscale spectrum in the extended colorset to a range from
    # yellow (fef502) to red (e70f30).

    my $base = 'ffff00';
    for(232..255) {
      #  ff, ff, 00
      my($r, $g, $b) = $base =~ /(..)(..)(..)/;

      $r = hex($r); # 255
      $g = hex($g); # 255
      $b = hex($b); # 0

      $r -= 1;  # 254
      $g -= 10; # 245
      $b += 2;  # 2

      $r = sprintf("%.2x", $r);
      $g = sprintf("%.2x", $g);
      $b = sprintf("%.2x", $b);

      $base = $r . $g . $b;

      my $new = set_color($_, $base);
      print $new;
    }

=head1 DESCRIPTION

fg()
  Set foreground colors and attributes.

  expects a string with an attribute attached to it as its first argument,
  and optionally any number of additional strings which the operation will be
  performed upon.
  If the internal $AUTORESET variabe is non-zero (default), the list of strings
  will be mapped with the attribute in front and the 'reset' attribute in the
  end. This is for convience, but the behaviour can be changed by calling
  Term::ExtendedColor::autoreset(0). Note that you will have to reset manually
  though, or else the set attributes will last after your script is finished,
  resulting in the prompt looking funny.

  If you pass an invalid attribute, the original data will be returned
  unmodified.

bg()
  Like fg(), but sets background colors.

uncolor()
  strips the input data from escape sequences.

set_color()
  change color index n value to color hex.

get_colors()
  returns a hash reference with all available attributes.

=head1 SEE ALSO

  Term::ANSIColor

=head1 AUTHOR

Written by Magnus Woldrich

=head1 COPYRIGHT

Copyright 2010 Magnus Woldrich <magnus@trapd00r.se>. This program is free
software; you may redistribute it and/or modify it under the same terms as
Perl itself.

=cut


1;
