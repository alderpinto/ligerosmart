# --
# Copyright (C) 2012-2018 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Znuny4OTRS::TicketToUnitTest::HistoryType::CustomerUpdate;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
);

use Kernel::System::VariableCheck qw(:all);
use parent qw( Kernel::System::Znuny4OTRS::TicketToUnitTest::Base );

sub Run {
    my ( $Self, %Param ) = @_;

    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    NEEDED:
    for my $Needed (qw(CustomerID CustomerUser)) {

        next NEEDED if defined $Param{$Needed};

        $LogObject->Log(
            Priority => 'error',
            Message  => "Parameter '$Needed' is needed!",
        );
        return;
    }

    my $Output = <<OUTPUT;
\$Success = \$TicketObject->TicketCustomerSet(
    No       => '$Param{CustomerID}',
    User     => '$Param{CustomerUser}',
    TicketID => \$TicketID,
    UserID   => \$UserID,
);
\$Self->True(
    \$Success,
    'TicketCustomerSet to "$Param{CustomerUser}" was successfull.',
);

OUTPUT

    return $Output;
}

1;
