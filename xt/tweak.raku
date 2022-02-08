use v6;
use NativeCall;

use Gnome::N::GlibToRakuTypes;
use Gnome::N::N-GObject;

use Gnome::Gtk3::Window;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Main;

use Gnome::Gdk3::Display;
use Gnome::Gdk3::Window;

use Gnome::Gdk3::Events;

#class N-GObject is repr('CPointer') is export { }

class N-EvBttn is export is repr('CStruct') {
  has GEnum $.type;
  has Pointer $.window;
  has gdouble $.x;
  has gdouble $.y;

  submethod BUILD ( :$type, :$x, :$y ) {
    $!type = $type.value;
    $!x = ($x // 0).Num;
    $!y = ($y // 0).Num;
  }

  submethod TWEAK ( :$window is copy ) {
note 'self: ', self, ', ', self.^name;
    if ?$window {
      $window .= get-native-object-no-reffing unless $window ~~ N-GObject;
note 'fv1: ', $window.gist, ', ', $window.defined;
#      $!window := $window;
      $!window = nativecast( Pointer, $window);
    }
  }
}

my Gnome::Gtk3::Main $main .= new;
my Gnome::Gtk3::Button $b .= new(:label<Start>);
with my Gnome::Gtk3::Window $gtk-window .= new {
  .set-title('test events');
  .add($b);
  .show-all;
}

my Gnome::Gdk3::Display $display = $gtk-window.get-display-rk;
my N-GObject $gdk-window-no = $gtk-window.get-window;

my $no = N-EvBttn.new(
  :type(GDK_BUTTON_PRESS), :x(20e0), :y(20e0), :time(time),
  :window($gdk-window-no)
);

note "event: $no.gist()";