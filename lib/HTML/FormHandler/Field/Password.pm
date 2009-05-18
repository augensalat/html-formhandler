package HTML::FormHandler::Field::Password;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Field::Text';
our $VERSION = '0.02';

has '+widget'           => ( default => 'password' );
has '+min_length'       => ( default => 6 );
has '+password'         => ( default => 1 );
has '+required_message' => ( default => 'Please enter a password in this field' );
has 'noupdate_if_empty' => ( isa => 'Bool', is => 'rw', default => '0' );
has 'ne_username'       => ( isa => 'Str',  is => 'rw' );

apply(
   [
      {
         check   => sub { $_[0] !~ /\s/ },
         message => 'Password can not contain spaces'
      },
      {
         check => sub { $_[0] !~ /\W/ },
         message => 'Password must be made up of letters, digits, and underscores'
      },
      {
         check   => sub { $_[0] !~ /^\d+$/ },
         message => 'Password must not be all digits'
      },
   ]
);

after 'process' => sub {
   my $self = shift;

   if ( $self->noupdate_if_empty && !$self->value )
   {
      $self->noupdate(1);
      $self->clear_errors;
   }
};

sub validate
{
   my $self = shift;

   return unless $self->SUPER::validate;

   my $value = $self->value;
   if ( $self->form && $self->ne_username )
   {
$DB::single=1;
      my $username = $self->form->get_param( $self->ne_username );
      return $self->add_error( 'Password must not match ' . $self->ne_username )
         if $username && $username eq $value;
   }
   return 1;
}

=head1 NAME

HTML::FormHandler::Field::Password - Input a password

=head1 DESCRIPTION

Validates that it does not contain spaces (\s),
contains only wordcharacters (alphanumeric and underscore \w),
is not all digits, and is at least 6 characters long.

You can add additional checks by using 'apply' in the field definition:

   has_field 'password' => ( type => 'Password', 
          apply => [ { check => sub { .... },
                       message => 'Password must contain....' } ],
   );
                 

=head2 ne_username

Set this attribute to the name of your username field (default 'username')
if you want to check that the password is not the same as the username.
Does not check by default.

=head2 noupdate_if_empty

If this flag is set then the database will not be updated if the field is empty.
This is useful when there are password fields in a form that should be
processed only if something is entered

=head2 widget

Fields can be given a widget type that is used as a hint for
the code that renders the field.

This field's widget type is: "".

=head1 AUTHORS

Gerda Shank

=head1 COPYRIGHT

See L<HTML::FormHandler> for copyright.

This library is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;
no Moose;
1;
