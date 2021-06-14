# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::TicketLigero::StateSearch;

use strict;
use warnings;

use Kernel::System::VariableCheck qw( :all );

use base qw(
    Kernel::GenericInterface::Operation::Common
);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Operation::TicketLigero::StateSearch - GenericInterface Queues List

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Operation->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw(DebuggerObject WebserviceID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!",
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    # get config for this screen
    #$Self->{Config} = $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::Operation::GeneralCatalogGetValues');

    return $Self;
}

=pod
@api {post} /state/search Get all states avaliable.
@apiName Search
@apiGroup State
@apiVersion 1.0.0

@apiExample Example usage:
  {
    "SessionID": "vbX9n8cxJSdig0QODzl3Vrl74ip6jNGP"
  }

@apiParam (Request body) {String} [UserLogin] User login to create sesssion.
@apiParam (Request body) {String} [Password] Password to create session.
@apiParam (Request body) {String} SessionID session id generated by session create method.

@apiErrorExample {json} Error example:
  HTTP/1.1 200 Success
  {
    "Error": {
      "ErrorCode": "StateSearch.AuthFail",
      "ErrorMessage": "StateSearch: Authorization failing!"
    }
  }
@apiSuccessExample {json} Success example:
  HTTP/1.1 200 Success
  {
    "Items": [
      {
        "Value": "closed successful",
        "Key": "2"
      },
      {
        "Value": "removed",
        "Key": "5"
      },
      {
        "Value": "new",
        "Key": "1"
      },
      {
        "Key": "3",
        "Value": "closed unsuccessful"
      },
      {
        "Value": "closed with workaround",
        "Key": "10"
      },
      {
        "Key": "9",
        "Value": "merged"
      },
      {
        "Key": "8",
        "Value": "pending auto close-"
      },
      {
        "Value": "open",
        "Key": "4"
      },
      {
        "Key": "7",
        "Value": "pending auto close+"
      },
      {
        "Key": "6",
        "Value": "pending reminder"
      }
    ]
  }
=cut
sub Run {
    my ( $Self, %Param ) = @_;

    my ( $UserID, $UserType ) = $Self->Auth(
        %Param,
    );

    my $StateObject = $Kernel::OM->Get('Kernel::System::State');

    return $Self->ReturnError(
        ErrorCode    => 'GeneralCatalogGetValues.AuthFail',
        ErrorMessage => "GeneralCatalogGetValues: Authorization failing!",
    ) if !$UserID;

    my %StateList = $StateObject->StateList(
       UserID => $UserID,
       Valid  => 1,
   );

    my @values = ();

    if(%StateList){

        while (my ($key, $value) = each (%StateList)){
            push @values,{Key=>$key,Value=>$value};
        }

        return {
            Success => 1,
            Data    => {
                Items => \@values
            },
        };
    }

    return {
        Success => 1,
        Data    => {},
    };
    
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut