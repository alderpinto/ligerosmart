# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::TicketLigero::PrioritySearch;

use strict;
use warnings;

use Kernel::System::VariableCheck qw( :all );

use base qw(
    Kernel::GenericInterface::Operation::Common
);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Operation::TicketLigero::PrioritySearch - GenericInterface Queues List

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
@api {post} /priority/search Get all possibles priority to use.
@apiName Search
@apiGroup Priority
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
      "ErrorCode": "PrioritySearch.AuthFail",
      "ErrorMessage": "PrioritySearch: Authorization failing!"
    }
  }
@apiSuccessExample {json} Success example:
  HTTP/1.1 200 Success
  {
    "Items": [
      {
        "Key": "4",
        "Value": "4 high"
      },
      {
        "Key": "5",
        "Value": "5 very high"
      },
      {
        "Key": "2",
        "Value": "2 low"
      },
      {
        "Key": "3",
        "Value": "3 normal"
      },
      {
        "Key": "1",
        "Value": "1 very low"
      }
    ]
  }
=cut
sub Run {
    my ( $Self, %Param ) = @_;

    my ( $UserID, $UserType ) = $Self->Auth(
        %Param,
    );

     my $PriorityObject = $Kernel::OM->Get('Kernel::System::Priority');

    return $Self->ReturnError(
        ErrorCode    => 'GeneralCatalogGetValues.AuthFail',
        ErrorMessage => "GeneralCatalogGetValues: Authorization failing!",
    ) if !$UserID;

    my %PriorityList = $PriorityObject->PriorityList(
       Valid => 1,
    );

    my @values = ();

    if(%PriorityList){

        while (my ($key, $value) = each (%PriorityList)){
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