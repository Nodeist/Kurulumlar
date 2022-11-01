package cmd

import "sync"

type NotificationService interface {
	// send one time alert for validator
	SendValidatorAlertNotification(config *NodecordConfig, vm *ValidatorMonitor, stats ValidatorStats, alertNotification *ValidatorAlertNotification)

	// update (or create) realtime status for validator
	UpdateValidatorRealtimeStatus(configFile string, config *NodecordConfig, vm *ValidatorMonitor, stats ValidatorStats, writeConfigMutex *sync.Mutex)
}
